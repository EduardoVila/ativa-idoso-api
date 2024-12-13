# frozen_string_literal: true

module AnalysisModules
  module ProScore
    class FamilyHoldingCommand < AnalysisModules::BaseModuleCommand
      def call
        unless family_holdings.present?
          return
        end

        @analysis_item.update(disapproval_situation: :reproved_by_relative)
      end

      private

      def performed?
        performed_searches.include? 'family_holding'
      end

      def reproved_relative?
        date = Time.zone.today - 30.days

        family_holdings.map do |family_holding|
          cpf = CPF::Formatter.format(family_holding.cpf_do_parente)

          Analysis::Item.joins(:predictions)
            .where(status: :done, cpf:)
            .where(
              'analysis_predictions.approved = false AND
              analysis_items.created_at >= :date', date:
            )
          .where.not(analysis_report_id: analysis_item.analysis_report_id)
          .exists?
          end.include? true
        end

        def family_holdings
        return @analysis_item.pro_score_family_holdings if performed?

        if @analysis_item.error_status == 'pro_score_family_holdings'
          @analysis_item.update(error_status: :none)
        end

        begin
          ::ProScore::FamilyHoldingIntegrator.new.load_data(@analysis_item)

          @analysis_item.reload.pro_score_family_holdings
        rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
          @analysis_item.update(
            status: :error, error_status: :pro_score_family_holdings
          )

          #TODO: ScoreReportSyncCommand.call(@analysis_item.score_report)
        end
      end
    end
  end
end
