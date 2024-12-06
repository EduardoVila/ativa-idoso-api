# frozen_string_literal: true

module AnalysisModules
  class PredictionCommand < BaseModuleCommand
    def call(analysis_item)
      Analysis::PredictionIntegrator.new.create_resource(analysis_item)
    end
  end
end
