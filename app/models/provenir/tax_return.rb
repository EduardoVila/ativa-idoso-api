# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_tax_returns
#
#  id                          :bigint           not null, primary key
#  bank                        :string
#  batch                       :string
#  branch                      :string
#  capture_date                :datetime
#  creation_date               :datetime
#  is_vip_branch               :boolean
#  last_update_date            :datetime
#  status                      :string
#  year                        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_financial_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_tax_return_financial_datum_id  (provenir_financial_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_financial_datum_id => provenir_financial_data.id)
#
module Provenir
  class TaxReturn < ApplicationRecord
    belongs_to :financial_datum,
               class_name: 'Provenir::FinancialDatum',
               foreign_key: 'provenir_financial_datum_id',
               inverse_of: :tax_returns

  end
end
