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
