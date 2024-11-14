# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_addresses
#
#  id                     :bigint           not null, primary key
#  address_line           :string
#  district               :string
#  zip_code               :string
#  country                :string
#  city                   :string
#  state                  :string
#  serasa_registration_id :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
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
