# frozen_string_literal: true

module Analysis
  class StepCommand < ApplicationCommand
    attr_reader :analysis_item

    def initialize(analysis_item)
      super()
      @analysis_item = analysis_item
    end

    def call
      current_analysis = analysis_item.clone_of || analysis_item

      Analysis::Step.enabled.order(:index_order).each do |step|
        analysis_item.steps << step

        invoke_steps(current_analysis, step.command_class)

        next if analysis_item.status.eql?('wip')

        break
      end
    end

    private

    def invoke_steps(current_analysis, command_class)
      if command_class == 'Analysis::PredictionCommand' # Last step
        result = Invoker.execute(:a_step, current_analysis, command_class)

        return finished_analysis_item(result)
      end

      result = Invoker.execute(:a_step, current_analysis, command_class)

      return if result[:approved]

      create_analysis_prediction if command_class == 'PrePredictionCommand'

      finished_analysis_item(result)
    end

    # This method serves as a loop breaker for the step processing
    def finished_analysis_item(result)
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
