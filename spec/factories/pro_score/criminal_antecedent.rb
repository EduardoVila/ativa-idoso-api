# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_criminal_antecedent,
          class: 'ProScore::CriminalAntecedent' do
    numero_plugin { '6018' }
    numero_da_certidao { '68144972035' }
    certidao { 'SERVICO PUBLICO FEDERAL MINISTERIO' }
    data_da_emissao { '20/04/2023' }
    hora_da_emissao { '11:19:03' }

    report factory: :pro_score_report
  end
end
