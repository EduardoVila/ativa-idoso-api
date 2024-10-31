# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_phone, class: 'BoaVista::Phone' do
    ddd { Faker::PhoneNumber.area_code }
    number { Faker::PhoneNumber.subscriber_number(length: 9) }
    phone_type { 'FIXO' }

    boa_vista_cadastral_location
  end
end
