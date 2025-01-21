# frozen_string_literal: true

require_relative '../provider_command'

module Analysis
  class PredictionCommand < ProviderCommand
    attr_reader :analysis_item

    def call
      if analysis_item.alpop_prediction_error_status?
        analysis_item.update(error_status: :none)
      end

      begin
        Analysis::PredictionIntegrator.new.create_resource(analysis_item)

        success_hash
      rescue StandardError
        analysis_item.update(error_status: :alpop_prediction)

        failure_hash
      end
    end
  end
end
