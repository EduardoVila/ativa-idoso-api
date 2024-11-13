# frozen_string_literal: true

module ProScore
  class CommercialRelationIntegrator < BaseSearchIntegrator

    private

    def search_id
      273_777
    end

    def related_plugins
      {
        'CommercialRelation' => 219
      }
    end
  end
end
