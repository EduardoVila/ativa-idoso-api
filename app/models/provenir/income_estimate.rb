# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :bigint           not null, primary key
#  mte                         :string
#  company_ownership           :string
#  ibge                        :string
#  bigdata                     :string
#  bigdata_v2                  :string
#  provenir_financial_datum_id :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
module Provenir
  class IncomeEstimate < ApplicationRecord
    belongs_to :financial_datum,
               class_name: 'Provenir::FinancialDatum',
               foreign_key: 'provenir_financial_datum_id',
               inverse_of: :income_estimate

    validates :provenir_financial_datum_id, uniqueness: true
  end
end
