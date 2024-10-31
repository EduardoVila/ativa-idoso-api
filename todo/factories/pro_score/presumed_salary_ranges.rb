# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_presumed_salary_range,
          class: 'ProScore::PresumedSalaryRange' do
    numero_plugin { '412' }
    codigo_da_faixa_salarial { '3' }
    faixa_salarial { 'E' }
    descricao_da_faixa { 'de 02 a 03 salarios minimos' }

    report { create :pro_score_report }
  end
end
