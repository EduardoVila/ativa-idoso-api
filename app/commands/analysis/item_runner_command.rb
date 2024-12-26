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
      return sync_report if done_or_not_found?

      analysis_item.update(status: :wip)

      run_boa_vista_cadastral unless analysis_item.name.present?

      return if boa_vista_error?

      run_analysis_step
      sync_report
    end

    private

    def done_or_not_found?
      %w[done not_found].include?(analysis_item.status)
    end

    def sync_report
      InvokerCommand.execute(:analysis_report_sync_command, analysis_report)
    end

    def run_boa_vista_cadastral
      InvokerCommand.execute(:boa_vista_cadastral_command, analysis_item)
    end

    def boa_vista_error?
      analysis_item.error_status.eql?('boa_vista')
    end

    def run_analysis_step
      InvokerCommand.execute(:analysis_step_command, analysis_item)
    end
  end
end
