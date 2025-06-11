# frozen_string_literal: true

# RerunCloneAnalysisItemJob is a Sidekiq job that handles reprocessing of analysis items
# that were previously identified as clones of other items.
#
# This job performs the following operations:
# 1. Resets the clone status of an analysis item by clearing its clone_of_id
# 2. Updates the item status back to :todo and clears associated data
# 3. Reprocesses the analysis item through the analysis pipeline
# 4. Updates the associated webhook event with the new analysis results
# 5. Triggers the webhook notification
#
# The job includes retry exhaustion handling that logs failures and updates
# the webhook event status to :error when all retries are exhausted.
#
# @example
#   RerunCloneAnalysisItemJob.perform_async(analysis_item_id)
#
# @param analysis_item_id [Integer] The ID of the Analysis::Item to reprocess
#
# Sidekiq Configuration:
# - Queue: :rerun_clone_analysis_item
# - Retries: Uses Sidekiq's default retry mechanism with custom exhaustion handling

class RerunCloneAnalysisItemJob
  include Sidekiq::Job

  sidekiq_options(queue: :rerun_clone_analysis_item)

  sidekiq_retries_exhausted do |msg, ex|
    analysis_item_id = msg['args'][0]

    analysis_item = Analysis::Item.select(:id, :analysis_report_id)
      .find(analysis_item_id)
    return unless analysis_item

    webhook_event = Api::WebhookEvent.find_by(
      analysis_report_id: analysis_item.analysis_report_id
    )
    return unless webhook_event

    Sidekiq.logger.info(
      <<~EXHAUSTED
        Job exhaustion!
        RerunCloneAnalysisItemJob failed after retries exhausted for analysis item ID: #{analysis_item_id}.
        Exception: #{ex.message}
        Webhook Event ID: #{webhook_event.id}
      EXHAUSTED
    )

    webhook_event&.update(status: :error, response: ex.message)
  end

  def perform(analysis_item_id)
    analysis_item = find_analysis_item(analysis_item_id)
    return unless analysis_item&.clone_of_id.present? # Ensure the item is a clone

    webhook_event = find_webhook_event(analysis_item.analysis_report_id)
    return unless webhook_event

    analysis_report = analysis_item.report

    ApplicationRecord.transaction do
      webhook_event.update!(status: :processing, job_id: jid)
      analysis_item.update!(clone_of_id: nil, status: :todo, name: nil)
      analysis_report.update!(status: :wip)
      analysis_item.predictions.destroy_all
      analysis_item.steps.destroy_all
    end

    process_analysis_item(analysis_item)

    update_webhook_event_payload(webhook_event, analysis_report)

    trigger_webhook_event(webhook_event)
  end

  private

  def find_analysis_item(analysis_item_id)
    Analysis::Item.find(analysis_item_id)
  end

  def find_webhook_event(analysis_report_id)
    Api::WebhookEvent.find_by(analysis_report_id: analysis_report_id)
  end

  def process_analysis_item(analysis_item)
    Invoker.execute(:analysis_item_runner_command, analysis_item)
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update!(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
