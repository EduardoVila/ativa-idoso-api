# frozen_string_literal: true

require_relative '../concerns/command_results_hash'

module AnalysisModules
  class BaseModuleCommand
    include ::CommandResultsHash

<<<<<<< HEAD
    attr_reader :analysis_item

    def initialize(analysis_item)
      @analysis_item = analysis_item
    end

    def self.call(*)
      new(*).call
    end

=======
>>>>>>> dev
    def call
      raise NotImplementedError
    end

<<<<<<< HEAD
    private

    def performed_searches
      analysis_item.reload.pro_score_report&.performed_searches || []
    end
=======
    # private
>>>>>>> dev

    # def performed?
    #   raise NotImplementedError
    # end

<<<<<<< HEAD
=======
    # TODO: PRO_SCORE MODULES
    # def performed_searches
    #   analysis_item.reload.pro_score_report&.performed_searches || []
    # end

>>>>>>> dev
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
