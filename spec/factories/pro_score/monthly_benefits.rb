# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_monthly_benefits
#
#  id                                :bigint           not null, primary key
#  numero_plugin                     :string
#  mes_competencia                   :string
#  mes_referencia                    :string
#  uf                                :string
#  nome_municipio                    :string
#  nis_beneficiario                  :string
#  numero_beneficio                  :string
#  beneficio_concedido_judicialmente :string
#  valor_parcela                     :string
#  pro_score_report_id               :bigint           not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
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

    report factory: :pro_score_report
  end
end
