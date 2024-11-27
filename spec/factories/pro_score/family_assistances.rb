# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_assistances
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor                    :string
#  ultima_data_do_beneficio :string
#  consta_beneficio         :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_family_assistance, class: 'ProScore::FamilyAssistance' do
    numero_plugin { '443' }
    valor { '124,00' }
    ultima_data_do_beneficio { '05/12/2022' }
    consta_beneficio { 'SIM' }

    report factory: :pro_score_report
  end
end
