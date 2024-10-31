# frozen_string_literal: true

FactoryBot.define do
  factory :idwall_address, class: 'Idwall::Address' do
    main { Faker::Boolean.boolean }
    city { Faker::Address.city }
    number { Faker::Address.building_number }
    zip_code { Faker::Address.zip }
    state { Faker::Address.state }
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.community }
    people_at_address { '-1' }
    kind { 'RESIDENCIAL' }

    idwall_report
  end
end
