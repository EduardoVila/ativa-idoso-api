# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_commercial_relation,
          class: 'ProScore::CommercialRelation' do
    numero_plugin { '219' }
    cpfcnpj { Faker::CPF.pretty }
    razao_social { 'SAMARA RAFAELA PONTE 01328462407' }

    report { create :pro_score_report }
  end
end
