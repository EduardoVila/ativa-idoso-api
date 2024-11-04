# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::PartyDetail, type: :model do
  describe 'factories' do
    subject { build :provenir_party_detail }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:party)
        .class_name('Provenir::Party')
        .with_foreign_key('provenir_party_id')
        .inverse_of(:party_detail)
    end
  end
end
