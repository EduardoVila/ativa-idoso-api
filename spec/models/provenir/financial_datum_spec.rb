# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :bigint           not null, primary key
#  total_assets              :string
#  creation_date             :datetime
#  last_update_date          :datetime
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::FinancialDatum, type: :model do
  describe 'factories' do
    subject { build :provenir_financial_datum }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:financial_datum)
    end

    it do
      expect(subject).to have_many(:tax_returns)
        .class_name('Provenir::TaxReturn')
        .with_foreign_key('provenir_financial_datum_id')
        .inverse_of(:financial_datum)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:income_estimate)
        .class_name('Provenir::IncomeEstimate')
        .with_foreign_key('provenir_financial_datum_id')
        .inverse_of(:financial_datum)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:tax_returns) }
    it { is_expected.to accept_nested_attributes_for(:income_estimate) }
  end
end
