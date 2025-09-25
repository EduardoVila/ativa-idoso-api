# frozen_string_literal: true

VALID_MODELS = %w[acquisition balance control].freeze

namespace :prediction_reset do
  # Re-runs the prediction step for a given list of analysis reports. Usage: rake prediction_reset:run IDS=1,2,3 MODEL=control|acquisition
  desc 'Reset and re-run prediction steps for specified Analysis::Reports'
  task :run do
    require_relative '../../config/environments' # Environment setup
    require_relative '../../config/application' # Application setup
    # Define constants to avoid "magic strings" and typos

    ids_raw = ENV.fetch('IDS', '')
    if ids_raw.strip.empty?
      abort('Please provide report IDs. Usage: rake predict:run IDS=1,2,3')
    end

    model_override = ENV.fetch('MODEL', '')&.strip
    if model_override.present? && !VALID_MODELS.include?(model_override)
      abort("Invalid MODEL. Must be one of: #{VALID_MODELS.join(', ')}")
    end

    report_ids = ids_raw.split(',').map(&:to_i).reject(&:zero?).uniq

    report_ids.each do |report_id|
      PredictionResetJob.perform_async(report_id, model_override)
    end
  end
end
