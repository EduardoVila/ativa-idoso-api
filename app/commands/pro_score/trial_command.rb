# frozen_string_literal: true

require_relative '../provider_command'

module ProScore
  class TrialCommand < ProviderCommand
    def call # rubocop:disable Metrics/AbcSize
      if performed_searches.include?('trial') && approved?
        return analysis_item.pro_score_trials
      end

      if analysis_item.error_status == 'pro_score_trials'
        analysis_item.update(error_status: :none)
      end

      begin
        ::ProScore::TrialIntegrator.new.load_data(analysis_item)

        analysis_item.reload.pro_score_trials
      rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
        analysis_item.update(status: :error, error_status: :pro_score_trials)

        InvokerCommand.execute(
          :analysis_report_sync_command, analysis_item.report
        )
      end

      return if analysis_item.pro_score_trials.blank? || approved?

      reprove(analysis_item)
    end

    private

    def approved?
      analysis_item.pro_score_trials_approved?
    end

    def reprove(analysis_item)
      analysis_item.update(disapproval_situation: :reproved_by_trial)

      reprove_by_pre_validation(analysis_item)
    end
  end
end
