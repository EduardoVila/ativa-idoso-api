# frozen_string_literal: true

module AnalysisModules
  module ProScore
    class CommercialRelationCommand < AnalysisModules::BaseModuleCommand
      def call
        commercial_relations
      end

      private

      def performed?
        performed_searches.include? 'commercial_relation'
      end

      def commercial_relations
        return @analysis_item.pro_score_commercial_relations if performed?

        if @analysis_item.error_status == 'pro_score_commercial_relations'
          @analysis_item.update(error_status: :none)
        end

        begin
          ::ProScore::CommercialRelationIntegrator.new.load_data(@analysis_item)

          @analysis_item.reload.pro_score_commercial_relations
        rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
          @analysis_item.update(
            status: :error, error_status: :pro_score_commercial_relations
          )

          # TODO: ScoreReportSyncCommand.call(@analysis_item.score_report)
        end
      end
    end
  end
end
