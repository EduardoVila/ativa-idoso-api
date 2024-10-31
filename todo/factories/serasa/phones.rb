# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_phone, class: 'Serasa::Phone' do
    region_code { Faker::PhoneNumber.area_code }
    area_code { Faker::PhoneNumber.country_code }
    phone_number { Faker::PhoneNumber.phone_number }

    owner { create :serasa_registration }

    trait :registration do
      owner { create :serasa_registration }
    end

    trait :stolen_document do
      owner { create :serasa_stolen_document }
    end
  end
end
