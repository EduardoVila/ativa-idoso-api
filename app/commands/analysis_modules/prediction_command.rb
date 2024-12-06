# frozen_string_literal: true

module AnalysisModules
  class PredictionCommand < BaseModuleCommand
    attr_reader :analysis_item

    def call
      Analysis::PredictionIntegrator.new.create_resource(analysis_item)
    end
  end
end
