# frozen_string_literal: true

module ProScore
  class CriminalAntecedentIntegrator < BaseSearchIntegrator

    private

    def search_id
      267_328
    end

    def related_plugins
      {
        'CriminalAntecedent' => 6018
      }
    end
  end
end
