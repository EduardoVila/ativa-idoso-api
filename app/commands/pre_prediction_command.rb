# frozen_string_literal: true

class PrePredictionCommand < ProviderCommand
  def call
    Validators::PrePredictionValidatorService.call(analysis_item.reload)
  end
end
