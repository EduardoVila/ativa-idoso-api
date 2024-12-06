# frozen_string_literal: true

require_relative 'application_job'

class AnalysisReportJob < ApplicationJob
  queue_as :analysis_report

  def perform(serialized_analysis_report)
    analysis_report = Analysis::Report
      .deserialize_record(serialized_analysis_report)

    AnalysisReportRunnerCommand.call(analysis_report)
  end
end
