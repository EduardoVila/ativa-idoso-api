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
module Provenir
  class IncomeEstimate < ApplicationRecord
    belongs_to :financial_datum,
               class_name: 'Provenir::FinancialDatum',
               foreign_key: 'provenir_financial_datum_id',
               inverse_of: :income_estimate

    validates :provenir_financial_datum_id, uniqueness: true
  end
end
