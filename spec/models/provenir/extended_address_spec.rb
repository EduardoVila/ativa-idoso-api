# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_addresses
#
#  id                          :uuid             not null, primary key
#  total_addresses             :integer
#  total_active_addresses      :integer
#  total_work_addresses        :integer
#  total_personal_addresses    :integer
#  total_unique_addresses      :integer
#  total_address_passages      :integer
#  total_bad_address_passages  :integer
#  oldest_address_passage_date :datetime
#  newest_address_passage_date :datetime
#  provenir_big_data_corp_id   :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::ExtendedAddress, type: :model do
  describe 'factories' do
    subject { build :provenir_extended_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:extended_address)
    end

    it do
      expect(subject).to have_many(:addresses)
        .class_name('Provenir::Address')
        .with_foreign_key('provenir_extended_address_id')
        .inverse_of(:extended_address)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:addresses) }
  end
end
