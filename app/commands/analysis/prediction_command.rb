# frozen_string_literal: true

require_relative '../provider_command'

module Analysis
  class PredictionCommand < ProviderCommand
    attr_reader :analysis_item

    def call
      Analysis::PredictionIntegrator.new.create_resource(analysis_item)
    end
  end
end
