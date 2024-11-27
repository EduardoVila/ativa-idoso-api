# frozen_string_literal: true

module ProScore
  class BouncedCheckIntegrator < BaseSearchIntegrator

    private

    def search_id
      273_776
    end

    def related_plugins
      {
        'BouncedCheck' => 111
      }
    end
  end
end
