# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_addresses
#
#  id                              :bigint           not null, primary key
#  street_type                     :string
#  street                          :string
#  number                          :string
#  neighborhood                    :string
#  city                            :string
#  federal_unit                    :string
#  zip_code                        :string
#  complement                      :string
#  address_type                    :string
#  boa_vista_cadastral_location_id :bigint           not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
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
