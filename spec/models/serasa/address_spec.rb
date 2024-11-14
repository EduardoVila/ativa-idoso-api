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
require 'spec_helper'

RSpec.describe Serasa::Address, type: :model do
  describe 'factories' do
    subject { build :serasa_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :registration }
  end
end
