# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :uuid             not null, primary key
#  region_code  :string
#  area_code    :string
#  phone_number :string
#  owner_type   :string
#  owner_id     :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :serasa_phone, class: 'Serasa::Phone' do
    region_code { Faker::PhoneNumber.area_code }
    area_code { Faker::PhoneNumber.country_code }
    phone_number { Faker::PhoneNumber.phone_number }

    owner factory: :serasa_registration

    trait :registration do
      owner factory: :serasa_registration
    end

    trait :stolen_document do
      owner factory: :serasa_stolen_document
    end
  end
end
