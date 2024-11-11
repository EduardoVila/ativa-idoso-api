# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::ExtendedPhone, type: :model do
  describe 'factories' do
    subject { build :provenir_extended_phone }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to have_many(:phones)
        .class_name('Provenir::Phone')
        .with_foreign_key('provenir_extended_phone_id')
        .inverse_of(:extended_phone)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:phones) }
  end
end
