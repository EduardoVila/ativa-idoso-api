# frozen_string_literal: true

FactoryBot.define do
  factory :idwall_related_person, class: 'Idwall::RelatedPerson' do
    cpf { Faker::CPF.pretty }
    name { Faker::Name.name }
    kind { 'FAMILIA' }

    idwall_report
  end
end
