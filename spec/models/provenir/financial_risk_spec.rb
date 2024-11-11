# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::FinancialRisk, type: :model do
  describe 'factories' do
    subject { build :provenir_financial_risk }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:financial_risk)
    end
  end
end
