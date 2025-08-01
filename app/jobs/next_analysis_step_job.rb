# frozen_string_literal: true

# Job responsible for processing the next analysis step in a sequence of analysis operations.
#
# This Sidekiq job manages the execution of individual analysis steps within an analysis workflow.
# It handles webhook event updates, processes analysis commands, and triggers webhook notifications
# upon completion or failure.
#
# The job includes retry exhaustion handling that logs failures and updates webhook event status
# to error when all retries are consumed.
#
# @example Enqueue the job
#   NextAnalysisStepJob.perform_async(analysis_item_id, analysis_step_id)
#
# Parameters:
# - analysis_item_id: ID of the analysis item to process
# - analysis_step_id: ID of the specific analysis step to execute
#
# The job performs the following operations:
# 1. Validates input parameters and fetches required records
# 2. Updates webhook event status to processing
# 3. Executes the analysis step command
# 4. Updates webhook event payload with analysis results
# 5. Triggers webhook notification
#
# Skips execution if:
# - Required parameters are blank
# - Required records cannot be found
# - The analysis step has already been processed for the analysis item
#
# Sidekiq Configuration:
# - Queue: :next_analysis_step
# - Retry Handling: Uses Sidekiq's default retry mechanism with custom exhaustion handling

class NextAnalysisStepJob
  include Sidekiq::Job

  sidekiq_options(queue: :next_analysis_step)

  sidekiq_retries_exhausted do |msg, ex|
    analysis_item_id = msg['args'][0]
    analysis_step_id = msg['args'][1]

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
        NextAnalysisStepJob failed after retries exhausted for analysis item ID: #{analysis_item_id}, step ID: #{analysis_step_id}.
        Exception: #{ex.message}
        Webhook Event ID: #{webhook_event.id}
      EXHAUSTED
    )

    webhook_event&.update(status: :error, response: ex.message)
  end

  def perform(analysis_item_id, analysis_step_id)
    return if analysis_item_id.blank? || analysis_step_id.blank?

    item, step, report, events =
      prepare_job_objects(analysis_item_id, analysis_step_id)

    return if [item, step, report, events].any?(&:blank?)

    events.each { |event| event.update!(status: :processing, job_id: jid) }

    run_next_step(item, step.command_class)

    deliver_webhook_events(events, report)
  end

  private

  def prepare_job_objects(analysis_item_id, analysis_step_id)
    analysis_item = find_analysis_item(analysis_item_id)
    return if analysis_item.nil?

    analysis_step = find_analysis_step(analysis_step_id)
    return if analysis_step.nil?

    return if analysis_item.steps.exists?(id: analysis_step_id)

    analysis_report = analysis_item.report

    webhook_events = analysis_report.api_webhook_events.reject(&:processed?)
    return if webhook_events.blank?

    [analysis_item, analysis_step, analysis_report, webhook_events]
  end

  def find_analysis_item(analysis_item_id)
    Analysis::Item.includes(:report, :steps).find(analysis_item_id)
  end

  def find_analysis_step(analysis_step_id)
    Analysis::Step.select(:id, :command_class).find_by(id: analysis_step_id)
  end

  def run_next_step(analysis_item, command_class)
    Invoker.execute(:analysis_next_step_command, analysis_item, command_class)
  end

  def deliver_webhook_events(webhook_events, analysis_report)
    Api::WebhookDeliveryService.new.call(webhook_events, analysis_report.reload)
  end
end
