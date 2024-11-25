# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class BusinessRelationshipsItemSerializer < ApplicationSerializer
    attributes :id, :cpfcnpj, :name

    def name
      object.related_entity_name
    end

    def cpfcnpj
      object.related_entity_tax_id_number
    end
  end
end
