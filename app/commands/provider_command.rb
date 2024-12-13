# frozen_string_literal: true

require_relative 'concerns/command_results_hash'

class ProviderCommand
  include ::CommandResultsHash

  attr_reader :analysis_item

  def initialize(analysis_item)
    @analysis_item = analysis_item
  end

  def self.call(*)
    new(*).call
  end

  def call
    raise NotImplementedError
  end

  private

  # Useful in ProScore Commands
  def performed_searches
    analysis_item.reload.pro_score_report&.performed_searches || []
  end

  # Useful in ProScore Commands
  def reprove_by_pre_validation(analysis_item)
    Analysis::Prediction.create(
      label: 'pre_validation',
      item: analysis_item,
      approved: false
    )

    analysis_item.update(status: :done)
  end
end
