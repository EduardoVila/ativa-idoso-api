# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :uuid             not null, primary key
#  total_assets              :string
#  creation_date             :datetime
#  last_update_date          :datetime
#  provenir_big_data_corp_id :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module Provenir
  class FinancialDatum < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :financial_datum

    has_one :income_estimate,
            class_name: 'Provenir::IncomeEstimate',
            foreign_key: 'provenir_financial_datum_id',
            inverse_of: :financial_datum,
            dependent: :destroy

    has_many :tax_returns,
             class_name: 'Provenir::TaxReturn',
             foreign_key: 'provenir_financial_datum_id',
             inverse_of: :financial_datum,
             dependent: :destroy

    accepts_nested_attributes_for :income_estimate, :tax_returns

    alias_attribute :income_estimates, :income_estimate

    def income_estimates_attributes=(params)
      self.income_estimate_attributes = params
    end
  end
end
