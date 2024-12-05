# frozen_string_literal: true

module AnalysisModules
  module ProScore
    class TrialCommand < AnalysisModules::BaseModuleCommand
      def call
        if performed_searches.include?('trial') && performed?
          return @analysis_item.pro_score_trials
        end

        if @analysis_item.error_status == 'pro_score_trials'
          @analysis_item.update(error_status: :none)
        end

        begin
          ::ProScore::TrialIntegrator.new.load_data(@analysis_item)

          @analysis_item.reload.pro_score_trials
        rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
          @analysis_item.update(
            status: :error, error_status: :pro_score_trials
          )
          # TODO: ScoreReportSyncCommand.call(@analysis_item.score_report)
        end
      end

      private

      def approved?
        @analysis_item.pro_score_trials_approved?
      end

    end
  end
end
