# frozen_string_literal: true

module AnalysisModules
  module ProScore
    class BouncedCheckCommand < AnalysisModules::BaseModuleCommand
      attr_reader :analysis_item

      def call
        if performed_searches.include?('bounced_check')
          return reproved_hash(:reproved_by_bounced_check) if bounced_check?

          return success_hash
        end

        if analysis_item.error_status == 'pro_score_bounced_checks'
          analysis_item.update(error_status: :none)
        end

        begin
          ::ProScore::BouncedCheckIntegrator.new.load_data(analysis_item)
          return reproved_hash(:reproved_by_bounced_check) if bounced_check?

          success_hash
        rescue Errors::ProScore::ResponseError, Faraday::ConnectionFailed
          analysis_item.update(error_status: :pro_score_bounced_checks)

          failure_hash
        end
      end

      private

      def performed_searches
        analysis_item.reload.pro_score_report&.performed_searches || []
      end

      def bounced_check?
        analysis_item.reload

        analysis_item.pro_score_bounced_checks.present?
      end
    end
  end
end
