# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class IncomeEstimateSerializer < ApplicationSerializer
    attributes :id, :ibge, :bigdata, :bigdata_v2
  end
end
