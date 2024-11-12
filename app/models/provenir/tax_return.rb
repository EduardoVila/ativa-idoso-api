# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_tax_returns
#
#  id                          :uuid             not null, primary key
#  year                        :integer
#  status                      :string
#  bank                        :string
#  branch                      :string
#  batch                       :string
#  is_vip_branch               :boolean
#  capture_date                :datetime
#  creation_date               :datetime
#  last_update_date            :datetime
#  provenir_financial_datum_id :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
module Provenir
  class TaxReturn < ApplicationRecord
    belongs_to :financial_datum,
               class_name: 'Provenir::FinancialDatum',
               foreign_key: 'provenir_financial_datum_id',
               inverse_of: :tax_returns

  end
end
