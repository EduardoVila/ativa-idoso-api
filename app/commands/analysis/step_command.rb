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
        next if current_item.steps.include?(step)

        # Create a new item_step for the current step and associate it to current_item.
        current_item.steps << step

        # Get the item_step for the newly added current step.
        item_step = analysis_item.item_steps.find_by(step: step)

        # Mark step as in progress.
        item_step.update(execution_status: :wip, started_at: Time.current)

        # invoke step and update the analysis item status if necessary.
        invoke_step(current_item, step.command_class, item_step)

        # Continue running step by step if the analysis item status is wip.
        next if analysis_item.reload.status.eql?('wip')

        # Break the loop if the status is done/error/not_found.
        break
      end
    end

    private

    # This method invokes the step command and updates the analysis item status.
    def invoke_step(current_item, command_class, item_step)
      if command_class == 'Analysis::PredictionCommand' # Last step.
        run_prediction_step(current_item, command_class, item_step)

        return
      end

      result = run_regular_step(current_item, command_class, item_step)

      return if result[:approved]

      # Change status from wip to done/error/not_found to finish the loop.
      handle_disapproved_result(result, command_class)
    end

    # This method runs the regular steps of the analysis item.
    # It updates the execution status of the item_step and the analysis item.
    def run_regular_step(current_item, command_class, item_step)
      start_time = Time.current
      result = Invoker.execute(:a_step, current_item, command_class)

      update_step_execution_status(item_step, result, start_time)

      result
    end

    # This method runs the last step of the analysis item.
    # It updates the execution status of the item_step and the analysis item.
    def run_prediction_step(current_item, command_class, item_step)
      start_time = Time.current
      result = Invoker.execute(:a_step, current_item, command_class)

      update_step_execution_status(item_step, result, start_time)
      # Change status from wip to done/error/not_found to finish the loop.
      update_item_status(result)

      result
    end

    # This method handles the result of a step that was not approved.
    # It updates the analysis item status and creates an analysis prediction.
    def handle_disapproved_result(result, command_class)
      create_analysis_prediction if command_class == 'PrePredictionCommand'
      update_item_status(result)
    end

    # Update the execution status of an item_step based on the result.
    def update_step_execution_status(item_step, result, start_time)
      end_time = Time.current
      duration = end_time - start_time

      status = result[:status] == 'failure' ? :failed : :completed
      result = result.except(:status)

      item_step.update(
        execution_status: status,
        finished_at: end_time,
        duration: duration,
        result_summary: result
      )
    end

    # This method serves as a loop breaker for the step processing.
    # It updates the status of the analysis item based on the result of the step.
    # When creating integrations and commands make it return the command_results_hash
    #  with the status of the command execution.
    # This way, the method can update the analysis item status based on the command result
    #  and break the loop if necessary.
    # Furthermore, it centralizes the logic of updating the analysis item status.
    def update_item_status(result)
      case result[:status]
      when 'failure'
        analysis_item.update(
          status: :error,
          steps_execution_data: analysis_item.steps_execution_summary
        )
      when 'not_found'
        analysis_item.update(
          status: :not_found,
          steps_execution_data: analysis_item.steps_execution_summary
        )
      when 'success'
        handle_case_when_success(result)
      end
    end

    def handle_case_when_success(result)
      if result[:approved]
        analysis_item.update(
          status: :done,
          features: analysis_item.featurable,
          steps_execution_data: analysis_item.steps_execution_summary
        )
      elsif result[:disapproval_situation]
        analysis_item.update(
          status: :done,
          disapproval_situation: result[:disapproval_situation],
          features: analysis_item.featurable,
          steps_execution_data: analysis_item.steps_execution_summary
        )
      end
    end

    def create_analysis_prediction
      Analysis::Prediction.create(
        label: 'pre_prediction', item: analysis_item, approved: false
      )
    end
  end
end
