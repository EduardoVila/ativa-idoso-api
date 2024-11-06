# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_location, class: 'BoaVista::Location' do
    register_size { '323' }
    register_type { '501' }
    register { 'S' }
    public_place_type { Faker::Address.street_suffix }
    public_place_name { Faker::Address.street_name }
    public_place_number { Faker::Address.building_number }
    complement { Faker::Address.secondary_address }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip }
    ddd_1 { Faker::PhoneNumber.area_code }
    phone_1 { Faker::PhoneNumber.subscriber_number(length: 9) }
    ddd_2 { Faker::PhoneNumber.area_code }
    phone_2 { Faker::PhoneNumber.subscriber_number(length: 9) }
    ddd_3 { Faker::PhoneNumber.area_code }
    phone_3 { Faker::PhoneNumber.subscriber_number(length: 9) }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
