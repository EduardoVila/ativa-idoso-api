# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_risks
#
#  id                                    :bigint           not null, primary key
#  current_consecutive_collection_months :integer
#  estimated_income_range                :string
#  financial_risk_level                  :string
#  financial_risk_score                  :integer
#  is_currently_employed                 :boolean
#  is_currently_on_collection            :boolean
#  is_currently_owner                    :boolean
#  is_currently_receiving_assistance     :boolean
#  last365_days_collection_occurrences   :integer
#  last_occupation_start_date            :datetime
#  total_assets                          :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  provenir_big_data_corp_id             :bigint           not null
#
# Indexes
#
#  index_provenir_financial_risk_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
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
