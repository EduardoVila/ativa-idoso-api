# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_addresses
#
#  id                     :bigint           not null, primary key
#  address_line           :string
#  city                   :string
#  country                :string
#  district               :string
#  state                  :string
#  zip_code               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  serasa_registration_id :bigint           not null
#
# Indexes
#
#  index_serasa_addresses_on_serasa_registration_id  (serasa_registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_registration_id => serasa_registrations.id)
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
