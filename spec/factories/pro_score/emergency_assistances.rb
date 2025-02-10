# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_emergency_assistances
#
#  id                  :bigint           not null, primary key
#  codigo_do_municipio :string
#  enquadramento       :string
#  mes_disponibilizado :string
#  municipio           :string
#  numero_plugin       :string
#  observacao          :string
#  parcelas            :string
#  uf                  :string
#  valor               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_emergency_assistances_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
