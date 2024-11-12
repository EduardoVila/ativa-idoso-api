# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::Phone, type: :model do
  describe 'factories' do
    subject { build :provenir_phone }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:extended_phone)
        .class_name('Provenir::ExtendedPhone')
        .with_foreign_key('provenir_extended_phone_id')
        .inverse_of(:phones)
    end
  end
end
