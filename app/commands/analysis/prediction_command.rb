# frozen_string_literal: true

require_relative '../provider_command'

module Analysis
  class PredictionCommand < ProviderCommand
    attr_reader :analysis_item

    def call
      if analysis_item.prediction_error_status?
        analysis_item.update(error_status: :none)
      end

      begin
        integrator = Analysis::PredictionIntegrator.new
        prediction = integrator.create_resource(analysis_item)

        return approved_hash if prediction.approved

        reproved_hash(:prediction)
      rescue ::Errors::Analysis::PredictionPostResponseError, StandardError
        analysis_item.update(error_status: :prediction)

        failure_hash
      end
    end
  end
end
