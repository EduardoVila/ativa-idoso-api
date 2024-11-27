# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_emergency_assistances
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  mes_disponibilizado :string
#  codigo_do_municipio :string
#  municipio           :string
#  uf                  :string
#  parcelas            :string
#  valor               :string
#  enquadramento       :string
#  observacao          :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
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

    report factory: :pro_score_report
  end
end
