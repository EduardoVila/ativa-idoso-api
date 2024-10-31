# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_family_assistance, class: 'ProScore::FamilyAssistance' do
    numero_plugin { '443' }
    valor { '124,00' }
    ultima_data_do_beneficio { '05/12/2022' }
    consta_beneficio { 'SIM' }

    report { create :pro_score_report }
  end
end
