# frozen_string_literal: true

require_relative '../concerns/command_results_hash'

module AnalysisModules
  class BaseModuleCommand
    include ::CommandResultsHash

    attr_reader :analysis_item

    def call
      raise NotImplementedError
    end

    # private

    # def performed?
    #   raise NotImplementedError
    # end

    # def reprove_score
    #   Prediction.create(
    #     label: 'pre_validation',
    #     score:,
    #     approved: false
    #   )

    #   score.update(status: :done)
    # end
  end
end
