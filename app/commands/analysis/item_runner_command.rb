# frozen_string_literal: true

require_relative '../application_command'

module Analysis
  class ItemRunnerCommand < ApplicationCommand
    attr_reader :analysis_item, :analysis_report

    def initialize(analysis_item)
      super()
      @analysis_item = analysis_item
      @analysis_report = analysis_item.report
    end

    def call
      if %w[done not_found].include?(analysis_item.status)
        Analysis::ReportSyncCommand.call(analysis_report)

        return
      end

      analysis_item.update(status: :wip)

      run_boa_vista_cadastral_job(analysis_item)

      return if analysis_item.error_status.eql? 'boa_vista'

      analyze_cpf(analysis_item)

      Analysis::ReportSyncCommand.call(analysis_report)
    end

    private

    def analyze_cpf(analysis_item)
      current_analysis = analysis_item.clone_of || analysis_item

      Analysis::Step.enabled.order(:index_order).each do |step|
        analysis_item.steps << step

        analysis_modules_runner(
          step.command_class, current_analysis, analysis_item
        )

        next if analysis_item.status.eql? 'wip'

        break
      end
    end

    def analysis_modules_runner(command_class, current_analysis, analysis_item)
      if command_class == 'Analysis::PredictionCommand'
        return prediction_command_handler(current_analysis, analysis_item)
      end

      result = Object.const_get(command_class).call(current_analysis)

      return if result[:approved]

      if command_class == 'PrePredictionCommand'
        Analysis::Prediction.create(
          label: 'pre_prediction',
          item: analysis_item,
          approved: false
        )
      end

      update_analysis_item(result, analysis_item)
    end

    def prediction_command_handler(current_analysis, analysis_item)
      Analysis::PredictionCommand.call(current_analysis)

      analysis_item.update(status: :done)
    end

    def update_analysis_item(result, analysis_item)
      if result[:status] == 'failure'
        return analysis_item.update(status: :error)
      end

      if result[:status] == 'not_found'
        return analysis_item.update(status: :not_found)
      end

      analysis_item.update(
        status: :done,
        disapproval_situation: result[:disapproval_situation]
      )
    end

    def run_boa_vista_cadastral_job(analysis_item)
      return if analysis_item.name.present?

      BoaVistaCadastralJob.perform_now(analysis_item.id)
    end
  end
end
