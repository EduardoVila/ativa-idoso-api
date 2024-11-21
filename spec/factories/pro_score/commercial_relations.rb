# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :uuid             not null, primary key
#  numero_plugin       :string
#  cpfcnpj             :string
#  razao_social        :string
#  pro_score_report_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
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
