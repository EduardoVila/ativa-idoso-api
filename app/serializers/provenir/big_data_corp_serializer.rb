# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class BigDataCorpSerializer < ApplicationSerializer
    attributes :id, :business_relationship, :financial_datum, :related_person,
               :process

    def business_relationship
      serialize_record(object.business_relationship)
    end

    def financial_datum
      serialize_record(object.financial_datum)
    end

    def related_person
      serialize_record(object.related_person)
    end

    def process
      serialize_record(object.process)
    end
  end
end
