# frozen_string_literal: true

# Job responsible for retrying failed analysis items within an analysis report.
#
# This job is designed to handle cases where analysis items have failed during
# initial processing and need to be retried. It operates on a specific analysis
# report and processes only the items that are in an 'error' status.
#
# The job performs the following operations:
# 1. Finds the analysis report and associated webhook event
# 2. Checks if there are any items with 'error' status
# 3. Updates the webhook event status to 'processing' and analysis report status to 'wip'
# 4. Processes each failed analysis item using the analysis item runner command
# 5. Updates the webhook event payload with the refreshed analysis report data
# 6. Triggers the webhook event to notify external systems
#
# @param analysis_report_id [Integer] The ID of the analysis report containing failed items
#
# @example
#   RetryFailedAnalysisItemsJob.perform_async(123)
#
# Sidekiq Configuration:
# - Queue: :retry_failed_analysis_items
# - Includes exhausted retry handler that logs failure details and updates webhook event status
#
# Error Handling:
# - When retries are exhausted, logs the failure and updates the webhook event status to 'error'
# - Returns early if webhook event or analysis report cannot be found
# - Returns early if no items have 'error' status

class RetryFailedAnalysisItemsJob
  include Sidekiq::Job

  sidekiq_options(queue: :retry_failed_analysis_items)

  sidekiq_retries_exhausted do |msg, ex|
    analysis_report_id = msg['args'].first
    webhook_event = Api::WebhookEvent.find_by(
      analysis_report_id: analysis_report_id
    )
    return unless webhook_event

    logger = Logger.new($stdout)
    logger.info(
      <<~EXHAUSTED
        RetryFailedAnalysisItemsJob failed after retries exhausted for analysis report ID: #{analysis_report_id}.
        Exception: #{ex.message}
        Webhook Event ID: #{webhook_event.id}
      EXHAUSTED
    )

    webhook_event&.update(status: :error, response: ex.message)
  end
  def perform(analysis_report_id)
    return if analysis_report_id.blank?

    analysis_report = find_analysis_report(analysis_report_id)
    return unless analysis_report
    return unless analysis_report.items.any? { |item| item.status == 'error' }

    webhook_event = find_webhook_event(analysis_report_id)
    return unless webhook_event

    ApplicationRecord.transaction do
      webhook_event.update!(status: :processing, job_id: jid)
      analysis_report.update!(status: :wip)
    end

    process_items_with_error_status(analysis_report)

    update_webhook_event_payload(webhook_event, analysis_report)

    trigger_webhook_event(webhook_event)
  end

  private

  def find_analysis_report(analysis_report_id)
    Analysis::Report.find(analysis_report_id)
  end

  def find_webhook_event(analysis_report_id)
    Api::WebhookEvent.find_by(analysis_report_id: analysis_report_id)
  end

  def process_items_with_error_status(analysis_report)
    analysis_report.items.where(status: 'error').each do |analysis_item|
      Invoker.execute(:analysis_item_runner_command, analysis_item)
    end
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update!(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
