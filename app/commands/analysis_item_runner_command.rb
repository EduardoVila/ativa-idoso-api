# frozen_string_literal: true

require_relative 'application_command'

class AnalysisItemRunnerCommand < ApplicationCommand
  attr_reader :analysis_item, :analysis_report

  def initialize(analysis_item)
    @analysis_item = analysis_item
    @analysis_report = analysis_item.report
  end

  def call
    if %w[done not_found].include?(analysis_item.status)
      # AnalysisReportSyncCommand.call(score_report) TODO

      return
    end

    analysis_item.update(status: :wip)

    # run_boa_vista_cadastral TODO

    # process_cpf unless score.error_status.eql? 'boa_vista' TODO

    #  AnalysisReportSyncCommand.call(score_report) TODO
  end

  # private

  # def process_cpf
  #   running_score = score.clone_of || score

  #   Analysis::Step.enabled.order(:index_order).each do |step|
  #     score.steps << step

  #     command_class = step.command_class
  #     proccess_module(command_class, running_score)

  #     next if score.status.eql? 'wip'

  #     break
  #   end
  # end

  # def proccess_module(command_class, running_score)
  #   if command_class == 'ScoreModules::PredictionCommand'
  #     return prediction_command_handler(running_score)
  #   end

  #   result = Object.const_get(command_class).call(running_score)

  #   return if result[:approved]

  #   if command_class == 'ScoreModules::PrePredictionCommand'
  #     create_pre_prediction
  #   end

  #   update_score(result)
  # end

  # def update_score(result)
  #   return score.update(status: :error) if result[:status] == 'failure'
  #   return score.update(status: :not_found) if result[:status] == 'not_found'

  #   score.update(
  #     status: :done,
  #     disapproval_situation: result[:disapproval_situation]
  #   )
  # end

  # def create_pre_prediction
  #   Prediction.create(
  #     label: 'pre_prediction',
  #     score:,
  #     approved: false
  #   )
  # end

  # def prediction_command_handler(running_score)
  #   prediction = ScoreModules::PredictionCommand.call(running_score)

  #   prediction.update(score:)
  #   score.update(status: :done)
  # end

  # def run_boa_vista_cadastral
  #   return if score.name.present?

  #   BoaVistaCadastralJob.perform_now(score)
  # end
end
