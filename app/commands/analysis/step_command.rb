# frozen_string_literal: true

module Analysis
  class StepCommand < ApplicationCommand
    attr_reader :analysis_item

    def initialize(analysis_item)
      super()
      @analysis_item = analysis_item
    end

    def call
      current_item = analysis_item.clone_of || analysis_item

      Analysis::Step.enabled.order(:index_order).each do |step|
        analysis_item.steps << step

        invoke_steps(current_item, step.command_class)

        # Continue running step by step if the analysis item status is wip
        next if analysis_item.status.eql?('wip')

        # Break the loop if the status is done/error/not_found
        break
      end
    end

    private

    def invoke_steps(current_item, command_class)
      if command_class == 'Analysis::PredictionCommand' # Last step
        result = Invoker.execute(:a_step, current_item, command_class)

        # Change status from wip to done/error/not_found to finish the loop in the call method
        return finished_item_status_update(result)
      end

      result = Invoker.execute(:a_step, current_item, command_class)

      return if result[:approved]

      create_analysis_prediction if command_class == 'PrePredictionCommand'

      # Change status from wip to done/error/not_found to finish the loop in the call method
      finished_item_status_update(result)
    end

    # This method serves as a loop breaker for the step processing.
    # It updates the status of the analysis item based on the result of the step.
    # When creating integrations and commands make it return the command_results_hash
    #   with the status of the command execution.
    # This way, the method can update the analysis item status based on the command result
    #  and break the loop if necessary.
    # Furthermore, it centralizes the logic of updating the analysis item status.
    def finished_item_status_update(result)
      case result[:status]
      when 'failure'
        analysis_item.update(status: :error)
      when 'not_found'
        analysis_item.update(status: :not_found)
      when 'success'
        if result[:approved]
          analysis_item.update(
            status: :done, features: analysis_item.featurable
          )
        else
          analysis_item.update(
            status: :done,
            disapproval_situation: result[:disapproval_situation],
            features: analysis_item.featurable
          )
        end
      end
    end

    def create_analysis_prediction
      Analysis::Prediction.create(
        label: 'pre_prediction', item: analysis_item, approved: false
      )
    end
  end
end
