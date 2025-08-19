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
      return sync_analysis_report if analysis_item_done_or_not_found?

      analysis_item.update(status: :wip)

      if analysis_item.name.blank? && boa_vista_cadastral_enabled
        run_boa_vista_cadastral

        return if boa_vista_error?

        update_analysis_item_name
      end

      analyze_item_step_by_step

      sync_analysis_report
    end

    private

    def update_analysis_item_name
      analysis_item.update(name: analysis_item.reload.boa_vista_cadastral_name)
    end

    def analysis_item_done_or_not_found?
      %w[done not_found].include?(analysis_item.status)
    end

    def sync_analysis_report
      Invoker.execute(:analysis_report_sync_command, analysis_report.reload)
    end

    def run_boa_vista_cadastral
      Invoker.execute(:boa_vista_cadastral_command, analysis_item)
    end

    def boa_vista_error?
      analysis_item.error_status.eql?('boa_vista')
    end

    def analyze_item_step_by_step
      Invoker.execute(:analysis_step_by_step_command, analysis_item)
    end

    def boa_vista_cadastral_enabled
      ENV.fetch('BOA_VISTA_CADASTRAL_ENABLED', true)
    end
  end
end
