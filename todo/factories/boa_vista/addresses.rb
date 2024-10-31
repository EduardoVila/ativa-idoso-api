# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_address, class: 'BoaVista::Address' do
    street_type { 'R' }
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip }

    boa_vista_cadastral_location
  end
end
