# frozen_string_literal: true

module ProScore
  class PresumedIncomeIntegrator < BaseSearchIntegrator

    private

    def search_id
      273_781
    end

    def related_plugins
      {
        'ProprableProfession' => 404,
        'PresumedSalaryRange' => 412,
        'PresumedIncome' => 411
      }
    end
  end
end
