# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :uuid             not null, primary key
#  mte                         :string
#  company_ownership           :string
#  ibge                        :string
#  bigdata                     :string
#  bigdata_v2                  :string
#  provenir_financial_datum_id :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::IncomeEstimate, type: :model do
  describe 'factories' do
    subject { build :provenir_income_estimate }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:financial_datum)
        .class_name('Provenir::FinancialDatum')
        .with_foreign_key('provenir_financial_datum_id')
        .inverse_of(:income_estimate)
    end
  end
end
