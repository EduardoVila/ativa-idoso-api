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
        integrator = Analysis::PredictionIntegrator.new
        prediction = integrator.create_resource(analysis_item)

        if prediction.approved
          approved_hash
        else
          reproved_hash(:prediction)
        end
      rescue ::Errors::Analysis::PredictionPostResponseError, StandardError
        analysis_item.update(error_status: :alpop_prediction)

        failure_hash
      end
    end
  end
end
