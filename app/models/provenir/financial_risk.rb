# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_risks
#
#  id                                    :uuid             not null, primary key
#  total_assets                          :string
#  estimated_income_range                :string
#  is_currently_employed                 :boolean
#  is_currently_owner                    :boolean
#  last_occupation_start_date            :datetime
#  is_currently_on_collection            :boolean
#  last365_days_collection_occurrences   :integer
#  current_consecutive_collection_months :integer
#  is_currently_receiving_assistance     :boolean
#  financial_risk_score                  :integer
#  financial_risk_level                  :string
#  provenir_big_data_corp_id             :uuid             not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
module Provenir
  class FinancialRisk < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :financial_risk
  end
end
