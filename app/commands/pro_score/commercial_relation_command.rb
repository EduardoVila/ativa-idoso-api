# frozen_string_literal: true

require_relative '../provider_command'

module ProScore
  class CommercialRelationCommand < ProviderCommand
    def call
      if performed_searches.include?('commercial_relation')
        return analysis_item.pro_score_commercial_relations
      end

      if analysis_item.error_status == 'pro_score_commercial_relations'
        analysis_item.update(error_status: :none)
      end

      begin
        ::ProScore::CommercialRelationIntegrator.new.load_data(analysis_item)

        analysis_item.reload.pro_score_commercial_relations
      rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
        analysis_item.update(
          status: :error, error_status: :pro_score_commercial_relations
        )

        Invoker.execute(:analysis_report_sync_command, analysis_item.report)
      end
    end
  end
end
