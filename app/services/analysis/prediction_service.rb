# frozen_string_literal: true

require_relative '../application_service'

module Analysis
  class PredictionService < ApplicationService
    attr_reader :analysis_item

    def initialize(analysis_item)
      @analysis_item = analysis_item
    end

    def call
      integrator = Integrators::Analysis::Prediction.new

      integrator.create_resource(analysis_item)
    end
  end
end
