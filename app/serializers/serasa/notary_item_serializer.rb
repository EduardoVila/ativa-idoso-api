# frozen_string_literal: true

require_relative '../application_serializer'

module Serasa
  class NotaryItemSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :office_number, :office_name, :city,
               :federal_unit

    def value
      format('%.2f', object.amount)
    end
  end
end
