# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_emergency_assistance,
          class: 'ProScore::EmergencyAssistance' do
    numero_plugin { '458' }
    mes_disponibilizado { '12/2020' }
    codigo_do_municipio { '4119301' }
    municipio { 'PINHAO' }
    uf { 'PR' }
    parcelas { '9' }
    valor { '300,00' }
    enquadramento { 'EXTRA CADUN' }
    observacao { 'NAO HA' }

    report { create :pro_score_report }
  end
end
