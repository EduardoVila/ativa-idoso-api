# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_addresses
#
#  id                              :bigint           not null, primary key
#  address_type                    :string
#  city                            :string
#  complement                      :string
#  federal_unit                    :string
#  neighborhood                    :string
#  number                          :string
#  street                          :string
#  street_type                     :string
#  zip_code                        :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  boa_vista_cadastral_location_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_addresses_on_boa_vista_cadastral_location_id  (boa_vista_cadastral_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_location_id => boa_vista_cadastral_locations.id)
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
