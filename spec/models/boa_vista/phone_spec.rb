# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phones
#
#  id                              :bigint           not null, primary key
#  ddd                             :string
#  number                          :string
#  phone_type                      :string
#  boa_vista_cadastral_location_id :bigint           not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::Phone, type: :model do
  describe 'factories' do
    subject { build :boa_vista_phone }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral_location) }
  end
end
