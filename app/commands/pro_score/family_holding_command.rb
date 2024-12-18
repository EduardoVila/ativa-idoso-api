# frozen_string_literal: true

module ProScore
  class FamilyHoldingCommand < ProviderCommand
    def call
      return unless family_holdings.present? && reproved_relative?

      reprove(analysis_item)
    end

    private

    def reprove(analysis_item)
      analysis_item.update(disapproval_situation: :reproved_by_relative)

      reprove_by_pre_validation(analysis_item)
    end

    def performed?
      performed_searches.include? 'family_holding'
    end

    def reproved_relative?
      date = Time.zone.today - 30.days

      family_holdings.map do |family_holding|
        formatted_cpf = CPF::Formatter.format(family_holding.cpf_do_parente)

        Analysis::Item.joins(:predictions).where(status: :done).where("
          analysis_items.cpf = :cpf AND
          analysis_predictions.approved = false AND
          analysis_items.created_at >= :date
        ", cpf: formatted_cpf, date:).where.not(
          analysis_report_id: @analysis_item.analysis_report_id
        ).present?
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

        Analysis::ReportSyncCommand.call(analysis_item.report)
      end
    end
  end
end
