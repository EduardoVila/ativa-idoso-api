# frozen_string_literal: true

require_relative '../provider_command'

module ProScore
  class PresumedIncomeCommand < ProviderCommand
    def call
      if performed_searches.include? 'presumed_income'
        return @analysis_item.reload.pro_score_presumed_income
      end

      if @analysis_item.error_status == 'pro_score_presumed_income'
        @analysis_item.update(error_status: :none)
      end

      begin
        ::ProScore::PresumedIncomeIntegrator.new.load_data(@analysis_item)

        @analysis_item.reload.pro_score_presumed_income
      rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
        @analysis_item.update(
          status: :error, error_status: :pro_score_presumed_income
        )

        # TODO: ScoreReportSyncCommand.call(@analysis_item.score_report)
      end
    end

    private

    def income_valid?
      presumed_income.report.presumed_income_value > 800
    end
  end
end
