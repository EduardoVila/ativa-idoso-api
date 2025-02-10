# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :bigint           not null, primary key
#  creation_date             :datetime
#  last_update_date          :datetime
#  total_assets              :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_financial_datum_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
require_relative '../application_serializer'

module Provenir
  class FinancialDatumSerializer < ApplicationSerializer
    attributes :id, :total_assets, :income_estimate

    def income_estimate
      object.income_estimate&.serialize_record || {}
    end
  end
end
