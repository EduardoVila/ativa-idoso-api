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
require 'spec_helper'

RSpec.describe BoaVista::Address, type: :model do
  describe 'factories' do
    subject { build :boa_vista_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral_location) }
  end
end
