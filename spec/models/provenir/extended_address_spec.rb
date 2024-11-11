# frozen_string_literal: true

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
