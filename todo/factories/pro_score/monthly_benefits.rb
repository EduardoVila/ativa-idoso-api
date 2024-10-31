# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_monthly_benefit, class: 'ProScore::MonthlyBenefit' do
    numero_plugin { '247' }
    mes_competencia { '09/2023' }
    mes_referencia { '12/2023' }
    uf { 'SC' }
    nome_municipio { 'SOMBRIO' }
    nis_beneficiario { '1' }
    numero_beneficio { '125' }
    beneficio_concedido_judicialmente { 'SIM' }
    valor_parcela { '1000,00' }

    report { create :pro_score_report }
  end
end
