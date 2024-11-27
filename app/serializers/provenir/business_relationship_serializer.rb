# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class BusinessRelationshipSerializer < ApplicationSerializer
    attributes :id, :total_relationships, :total_ownerships, :total_employments,
               :total_partners, :total_clients, :total_suppliers, :items

    def items
      object.business_relationships_items.map do |business_relationships_item|
        business_relationships_item.serialize_record(
          with: Provenir::BusinessRelationshipsItemSerializer
        )
      end
    end
  end
end
