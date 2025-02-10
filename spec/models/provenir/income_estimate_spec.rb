# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :bigint           not null, primary key
#  bigdata                     :string
#  bigdata_v2                  :string
#  company_ownership           :string
#  ibge                        :string
#  mte                         :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_financial_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_income_estimate_financial_datum_id  (provenir_financial_datum_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_financial_datum_id => provenir_financial_data.id)
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
