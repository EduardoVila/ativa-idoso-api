# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_notary_item, class: 'Serasa::NotaryItem' do
    occurrence_date { Time.zone.today }
    amount { rand(1..1000) }
    office_number { rand(1..10) }
    office_name { Faker::Company.name }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }

    notary factory: :serasa_notary
  end
end
