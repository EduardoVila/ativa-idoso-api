# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_address, class: 'Serasa::Address' do
    address_line { Faker::Address.street_address }
    district { Faker::Address.community }
    zip_code { Faker::Address.zip_code  }
    country { Faker::Address.country }
    city { Faker::Address.city }
    state { Faker::Address.state }

    registration factory: :serasa_registration
  end
end
