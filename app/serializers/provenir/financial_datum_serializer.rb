# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :bigint           not null, primary key
#  total_assets              :string
#  creation_date             :datetime
#  last_update_date          :datetime
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
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
