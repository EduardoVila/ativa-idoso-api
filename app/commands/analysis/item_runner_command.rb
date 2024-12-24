# frozen_string_literal: true

require_relative '../application_command'

module Analysis
  class ItemRunnerCommand < ApplicationCommand
    attr_reader :analysis_item, :analysis_report

    def initialize(analysis_item)
      super()
      @analysis_item = analysis_item
      @analysis_report = analysis_item.report
    end

    def call
      if %w[done not_found].include?(analysis_item.status)
        InvokerCommand.execute(:analysis_report_sync_command, analysis_report)

        return
      end

      analysis_item.update(status: :wip)

      unless analysis_item.name.present?
        InvokerCommand.execute(:boa_vista_cadastral_command, analysis_item)
      end

      return if analysis_item.error_status.eql?('boa_vista')

      InvokerCommand.execute(:analysis_step_command, analysis_item)

      InvokerCommand.execute(:analysis_report_sync_command, analysis_report)
    end
  end
end
