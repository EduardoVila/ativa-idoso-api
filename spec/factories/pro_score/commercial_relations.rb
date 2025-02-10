# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :bigint           not null, primary key
#  cpfcnpj             :string
#  numero_plugin       :string
#  razao_social        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_commercial_relations_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
FactoryBot.define do
  factory :pro_score_commercial_relation,
          class: 'ProScore::CommercialRelation' do
    numero_plugin { '219' }
    cpfcnpj { Faker::CPF.pretty }
    razao_social { 'SAMARA RAFAELA PONTE 01328462407' }

    report factory: :pro_score_report
  end
end
