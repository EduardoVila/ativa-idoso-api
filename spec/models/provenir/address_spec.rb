# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::Address, type: :model do
  describe 'factories' do
    subject { build :provenir_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:extended_address)
        .class_name('Provenir::ExtendedAddress')
        .with_foreign_key('provenir_extended_address_id')
        .inverse_of(:addresses)
    end
  end
end
