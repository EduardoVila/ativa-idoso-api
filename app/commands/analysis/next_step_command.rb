module Analysis
  class NextStepCommand < ApplicationCommand
    attr_reader :analysis_item, :command_class, :analysis_report

    def initialize(analysis_item, command_class)
      super()
      @analysis_item = analysis_item
      @command_class = command_class
      @analysis_report = analysis_item.report
    end

    def call
      return if analysis_item.nil? || command_class.nil?

      enabled_step = find_analysis_step(command_class)
      return if enabled_step.nil?

      analysis_item.update!(status: :wip)

      current_item = analysis_item.clone_of || analysis_item
      return if current_item.steps.include?(enabled_step)

      process_next_step(current_item, enabled_step)

      update_model_features_and_steps_data(enabled_step.command_class)

      sync_analysis_report
    end

    private

    def find_analysis_step(command_class)
      Analysis::Step.find_by(command_class: command_class)
    end

    def process_next_step(current_item, enabled_step)
      current_item.steps << enabled_step

      item_step = current_item.item_steps.find_by(step: enabled_step)

      item_step.update(execution_status: :wip, started_at: Time.current)

      run_step(current_item, enabled_step.command_class, item_step)
    end

    def run_step(current_item, command_class, item_step)
      result = invoke_step(current_item, command_class, item_step)

      return if result[:approved]

      handle_disapproved_result(command_class)
    end

    def handle_disapproved_result(command_class)
      create_analysis_prediction if command_class == 'PrePredictionCommand'
    end

    def invoke_step(current_item, command_class, item_step)
      start_time = Time.current

      result = Invoker.execute(:a_step, current_item, command_class)

      update_step_execution_status(item_step, result, start_time)

      update_item_status(result)

      result
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

    def update_item_status(result)
      case result[:status]
      when 'failure'
        analysis_item.update(status: :error)
      when 'not_found'
        analysis_item.update(status: :not_found)
      when 'success'
        handle_case_when_success(result)
      end
    end

    def handle_case_when_success(result)
      if result[:approved]
        analysis_item.update(status: :done)
      elsif result[:disapproval_situation]
        analysis_item.update(
          status: :done,
          disapproval_situation: result[:disapproval_situation]
        )
      end
    end

    def create_analysis_prediction
      Analysis::Prediction.create(
        label: 'pre_prediction', item: analysis_item, approved: false
      )
    end

    def update_model_features_and_steps_data(command_class)
      if analysis_item.done? && command_class == 'Analysis::PredictionCommand'
        update_features
      end

      update_steps_data
    end

    def update_steps_data
      steps_data = analysis_item.steps_summary
      analysis_item.update(steps_data:)
    end

    def update_features
      features = analysis_item.featurable
      analysis_item.update(features:)
    end

    def sync_analysis_report
      Invoker.execute(:analysis_report_sync_command, analysis_report.reload)
    end
  end
end
