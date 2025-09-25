# frozen_string_literal: true

# This job resets the prediction step for an Analysis::Report,
# updates its status and item models, and then re-triggers the
# analysis for all of its items.
class PredictionResetJob
  include Sidekiq::Job
  sidekiq_options queue: 'default', retry: 3

  # Constants for clarity and to prevent typos
  PREDICTION_STEP_NAME = 'predictions'
  ACQUISITION_PROFILE  = 'acquisition'
  CONTROL_PROFILE      = 'control'

  # @param report_id [Integer] The ID of the Analysis::Report to process.
  # @param model_override [String, nil] The prediction model name ('control' or 'acquisition') to apply.
  #   If nil, the model is determined from the report's profile.
  def perform(report_id, model_override = nil)
    report = Analysis::Report.find(report_id)
    prediction_step = Analysis::Step.find_by!(name: PREDICTION_STEP_NAME)

    ApplicationRecord.transaction do
      # Step 1: Delete existing prediction item steps to allow re-running.
      delete_prediction_steps(report, prediction_step)

      # Step 2: Update the report's status and all its items' model names.
      update_analysis_report_and_items(report, model_override)
    end

    # Step 3: Re-run the analysis for each item.
    run_analysis_items(report)
  end

  private

  def delete_prediction_steps(report, prediction_step)
    item_ids = report.items.pluck(:id)

    return if item_ids.empty?

    Analysis::ItemStep.where(
      analysis_item_id: item_ids,
      analysis_step_id: prediction_step.id
    ).delete_all
  end

  def update_analysis_report_and_items(report, model_override)
    report.update(
      status: :todo,
      prediction_model_name: model_override
    )

    # Refresh steps_data to reflect deletions
    report.items.each do |item|
      item.update(
        status: :todo,
        steps_data: item.steps_summary
      )
    end
  end

  def run_analysis_items(analysis_report)
    analysis_report.reload.items.each do |item|
      Invoker.execute(:analysis_item_runner_command, item)
    end
  end
end
