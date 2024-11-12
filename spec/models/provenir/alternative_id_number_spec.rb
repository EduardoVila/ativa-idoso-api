# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::AlternativeIdNumber, type: :model do
  describe 'factories' do
    subject { build :provenir_alternative_id_number }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:alternative_id_number)
    end
  end
end
