# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships
#
#  id                        :bigint           not null, primary key
#  total_clients             :integer
#  total_employments         :integer
#  total_ownerships          :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_suppliers           :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_business_relationship_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
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
