# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::Alias, type: :model do
  describe 'factories' do
    subject { build :provenir_alias }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:alias)
    end
  end
end
