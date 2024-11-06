# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_check_item, class: 'Serasa::CheckItem' do
    occurrence_date { Time.zone.today }
    legal_square { 'APS' }
    bank_id { rand(1..100) }
    bank_name { Faker::Company.name }
    bank_agency_id { rand(1..1000) }
    check_count { rand(1..100) }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }
    check_number { 'CCF-BB' }
    alinea { rand(0..10) }

    check factory: :serasa_check
  end
end
