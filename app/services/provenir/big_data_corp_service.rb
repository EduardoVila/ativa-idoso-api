# frozen_string_literal: true

require_relative '../application_service'

module Provenir
  class BigDataCorpService < ApplicationService
    attr_reader :analysis_item

    def initialize(analysis_item)
      @analysis_item = analysis_item
    end

    def call
      integrator = Integrators::Provenir::BigDataCorp.new

      integrator.create_resource(analysis_item)
    end
  end
end
