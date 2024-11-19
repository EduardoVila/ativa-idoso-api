# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_addresses
#
#  id                              :uuid             not null, primary key
#  street_type                     :string
#  street                          :string
#  number                          :string
#  neighborhood                    :string
#  city                            :string
#  federal_unit                    :string
#  zip_code                        :string
#  complement                      :string
#  address_type                    :string
#  boa_vista_cadastral_location_id :uuid             not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
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
