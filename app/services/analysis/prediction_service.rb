# frozen_string_literal: true

require_relative '../application_service'

module Analysis
  class PredictionService < ApplicationService
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def call
      integrator = Integrators::Analysis::Prediction.new(item)

      integrator.post_request
    end
  end
end
