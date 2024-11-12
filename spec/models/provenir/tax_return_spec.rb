# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::TaxReturn, type: :model do
  describe 'factories' do
    subject { build :provenir_tax_return }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:financial_datum)
        .class_name('Provenir::FinancialDatum')
        .with_foreign_key('provenir_financial_datum_id')
        .inverse_of(:tax_returns)
    end
  end
end
