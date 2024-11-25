# frozen_string_literal: true

require_relative '../application_serializer'

module Serasa
  class NegativeItemSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :informant, :segment

    def informant
      object.creditor_name
    end

    def segment
      object.legal_nature
    end

    def value
      format('%.2f', object.amount)
    end
  end
end
