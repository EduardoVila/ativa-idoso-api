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

      analysis_report.update(status: :wip)

      create_analysis_items(analysis_report) && command_runner(analysis_report)
    end

    private

    def create_analysis_items(analysis_report)
      Analysis::CreateAnalysisItemsService.call(analysis_report)
    end

    def command_runner(analysis_report)
      analysis_report.items.each do |item|
        Analysis::ItemRunnerCommand.call(item)
      end
    end
  end
end
