# frozen_string_literal: true

require_relative '../application_command'

module Analysis
  class ReportRunnerCommand < ApplicationCommand
    attr_reader :analysis_report

    def initialize(analysis_report)
      super()
      @analysis_report = analysis_report
    end

    def call
      return if %w[done not_found].include?(analysis_report.status)

      Analysis::CreateAnalysisItemsService.call(analysis_report)

      analysis_report
    end
  end
end
