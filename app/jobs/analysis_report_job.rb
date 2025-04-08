# frozen_string_literal: true

require_relative 'application_job'

# AnalysisReportJob is a background job responsible for processing analysis reports.
# It performs the following steps:
# 1. Finds the analysis report by the given ID.
# 2. Finds the corresponding webhook event by the analysis report ID.
# 3. Updates the webhook event status to 'processing' and associates it with the job ID.
# 4. Executes the report runner command for the analysis report.
# 5. Iterates through each item in the reloaded analysis report and executes the analysis command chain.
# 6. Updates the webhook event payload with the serialized analysis report.
# 7. Executes the webhook trigger command for the webhook event.
#
# @param analysis_report_id [Integer] The ID of the analysis report to be processed.
class AnalysisReportJob < ApplicationJob
  queue_as :analysis_report

  def perform(analysis_report_id)
    analysis_report = find_analysis_report(analysis_report_id)
    webhook_event = find_webhook_event(analysis_report_id)

    return unless webhook_event

    webhook_event.update(status: :processing, job_id: job_id)

    run_analysis_report(analysis_report)

    return if analysis_report_done_or_not_found?(analysis_report)

    process_analysis_items(analysis_report)
    update_webhook_event_payload(webhook_event, analysis_report)
    trigger_webhook_event(webhook_event)
  end

  private

  def find_analysis_report(analysis_report_id)
    Analysis::Report.find(analysis_report_id)
  end

  def find_webhook_event(analysis_report_id)
    Api::WebhookEvent.find_by(event_id: analysis_report_id)
  end

  def run_analysis_report(analysis_report)
    Invoker.execute(:analysis_report_runner_command, analysis_report)
  end

  def analysis_report_done_or_not_found?(analysis_report)
    %w[done not_found].include?(analysis_report.status)
  end

  def process_analysis_items(analysis_report)
    analysis_report.reload.items.each do |item|
      Invoker.execute(:analysis_item_runner_command, item)
    end
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
