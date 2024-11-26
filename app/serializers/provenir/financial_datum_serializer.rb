# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class FinancialDatumSerializer < ApplicationSerializer
    attributes :id, :total_assets, :income_estimate

    def income_estimate
      object.income_estimate&.serialize_record || {}
    end
  end
end
