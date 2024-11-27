# frozen_string_literal: true

module ProScore
  class GovernmentalAssistanceIntegrator < BaseSearchIntegrator

    private

    def search_name
      'governmental_assistance'
    end

    def search_id
      267_327
    end

    def related_plugins
      {
        'FamilyAssistance' => 443,
        'EmergencyAssistance' => 458,
        'MonthlyBenefit' => 247
      }
    end
  end
end
