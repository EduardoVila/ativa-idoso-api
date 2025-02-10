# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :bigint           not null, primary key
#  area_code    :string
#  owner_type   :string
#  phone_number :string
#  region_code  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :bigint
#
# Indexes
#
#  index_serasa_phones_on_owner  (owner_type,owner_id) UNIQUE
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
