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

    Sidekiq.logger.info(
      <<~EXHAUSTED
        Job exhaustion!
        RetryFailedAnalysisItemsJob failed after retries exhausted for analysis report ID: #{analysis_report_id}.
        Exception: #{ex.message}
        Webhook Event ID: #{webhook_event.id}
      EXHAUSTED
    )

    webhook_event&.update(status: :error, response: ex.message)
  end

  def perform(analysis_report_id)
    return if analysis_report_id.blank?

    report, events = prepare_job_objects(analysis_report_id)

    return unless report && events.any?

    ApplicationRecord.transaction do
      events.each { |e| e.update!(status: :processing, job_id: jid) }

      report.update!(status: :wip)
    end

    run_items_with_error_status(report)

    deliver_webhook_events(events, report)
  end

  private

  def prepare_job_objects(analysis_report_id)
    analysis_report = find_analysis_report(analysis_report_id)

    return if analysis_report.nil?

    return if analysis_report.items.none? { |i| i.status == 'error' }

    webhook_events = analysis_report.api_webhook_events

    return if webhook_events.blank?

    [analysis_report, webhook_events]
  end

  def find_analysis_report(analysis_report_id)
    Analysis::Report.find(analysis_report_id)
  end

  def run_items_with_error_status(analysis_report)
    analysis_report.items.where(status: 'error').each do |analysis_item|
      Invoker.execute(:analysis_item_runner_command, analysis_item)
    end
  end

  def deliver_webhook_events(webhook_events, analysis_report)
    Api::WebhookDeliveryService.new.call(webhook_events, analysis_report.reload)
  end
end
