# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_assistances
#
#  id                       :bigint           not null, primary key
#  consta_beneficio         :string
#  numero_plugin            :string
#  ultima_data_do_beneficio :string
#  valor                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_family_assistances_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
