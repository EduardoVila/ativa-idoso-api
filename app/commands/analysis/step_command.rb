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

        invoke_steps(step.command_class, current_analysis, analysis_item)

        next if analysis_item.status.eql?('wip')

        break
      end
    end

    private

    def invoke_steps(command_class, current_analysis, analysis_item)
      if command_class == 'Analysis::PredictionCommand'
        InvokerCommand.execute(:a_step, current_analysis, command_class)

        return analysis_item.update(status: :done)
      end

      result = InvokerCommand.execute(:a_step, current_analysis, command_class)

      return if result[:approved]

      create_analysis_prediction if command_class == 'PrePredictionCommand'

      update_analysis_item(result, analysis_item)
    end

    def update_analysis_item(result, analysis_item)
      case result[:status]
      when 'error'
        return analysis_item.update(status: :error)
      when 'not_found'
        return analysis_item.update(status: :not_found)
      end

      analysis_item.update(
        status: :done,
        disapproval_situation: result[:disapproval_situation]
      )
    end

    def create_analysis_prediction(analysis_item)
      Analysis::Prediction.create(
        label: 'pre_prediction',
        item: analysis_item,
        approved: false
      )
    end
  end
end
