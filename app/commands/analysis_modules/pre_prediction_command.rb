# frozen_string_literal: true

module AnalysisModules
  class PrePredictionCommand < BaseModuleCommand
    def call
      AnalysisModules::PrePredictionValidatorService.call(analysis_item.reload)
    end
  end
end
