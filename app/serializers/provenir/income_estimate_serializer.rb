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
require_relative '../application_serializer'

module Provenir
  class IncomeEstimateSerializer < ApplicationSerializer
    attributes :id, :ibge, :bigdata, :bigdata_v2
  end
end
