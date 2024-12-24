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
    analysis_report = Analysis::Report.find(analysis_report_id)
    webhook_event = API::WebhookEvent.find_by(event_id: analysis_report.id)

    return unless webhook_event

    webhook_event.update(status: 'processing', job_id: job_id)

    InvokerCommand.execute(:analysis_report_runner_command, analysis_report)

    return if %w[done not_found].include?(analysis_report.status)

    analysis_report.reload.items.each do |item|
      InvokerCommand.execute(:analysis_item_runner_command, item)
    end

    webhook_event.update(payload: analysis_report.reload.serialize_record)

    InvokerCommand.execute(:webhook_trigger_command, webhook_event)
  end
end
