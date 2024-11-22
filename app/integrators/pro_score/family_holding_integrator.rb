# frozen_string_literal: true

module ProScore
  class FamilyHoldingIntegrator < BaseSearchIntegrator

    private

    def search_id
      273_782
    end

    def related_plugins
      {
        'FamilyHolding' => 454
      }
    end
  end
end
