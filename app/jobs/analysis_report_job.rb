# frozen_string_literal: true

require_relative 'application_job'

class AnalysisReportJob < ApplicationJob
  queue_as :analysis_report

  def perform(analysis_report_id)
    analysis_report = Analysis::Report.find(analysis_report_id)
    webhook_event = API::WebhookEvent.find_by(event_id: analysis_report.id)

    return unless webhook_event

    webhook_event.update(status: 'processing', job_id: job_id)

    Analysis::ReportRunnerCommand.call(analysis_report)

    webhook_event.update(payload: analysis_report.reload.serialize_record)

    API::WebhookTriggerCommand.call(webhook_event)
  end
end
