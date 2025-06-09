# frozen_string_literal: true

# AnalysisReportJob processes analysis reports and manages webhook events.
#
# This Sidekiq job handles the complete lifecycle of analysis report processing,
# including running analysis reports, processing individual analysis items,
# and triggering webhook events upon completion.
#
# The job includes retry exhaustion handling that logs failures and updates
# webhook event status to error when all retries are exhausted.
#
# @example Enqueue the job
#   AnalysisReportJob.perform_async(123)
#
# Job Flow:
# 1. Finds the analysis report and associated webhook event
# 2. Updates webhook event status to processing
# 3. Runs the analysis report using the analysis_report_runner_command
# 4. Processes each analysis item using analysis_item_runner_command
# 5. Updates webhook event payload with serialized analysis report
# 6. Triggers the webhook event using api_webhook_trigger_command
#
# Error Handling:
# - Returns early if webhook event or analysis report is not found
# - Skips processing if webhook event is already processed and analysis report is done
# - Logs detailed error information when retries are exhausted
# - Updates webhook event status to error on failure
#
# Sidekiq Configuration:
# - Queue: :analysis_report
# - Includes exhausted retry handler that logs failure details and updates webhook event status

class AnalysisReportJob
  include Sidekiq::Job

  sidekiq_options(queue: :analysis_report)

  sidekiq_retries_exhausted do |msg, ex|
    analysis_report_id = msg['args'].first
    webhook_event = Api::WebhookEvent.find_by(
      analysis_report_id: analysis_report_id
    )
    return unless webhook_event

    logger = Logger.new($stdout)
    logger.info(
      <<~EXHAUSTED
        AnalysisReportJob failed after retries exhausted for Analysis Report ID: #{analysis_report_id}.
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
    return if analysis_report.done?

    webhook_event = find_webhook_event(analysis_report_id)
    return unless webhook_event
    return if webhook_event.processed?

    webhook_event.update!(status: :processing, job_id: jid)

    run_analysis_report(analysis_report)

    process_analysis_items(analysis_report)

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

  def run_analysis_report(analysis_report)
    Invoker.execute(:analysis_report_runner_command, analysis_report)
  end

  def process_analysis_items(analysis_report)
    analysis_report.reload.items.each do |item|
      Invoker.execute(:analysis_item_runner_command, item)
    end
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update!(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
