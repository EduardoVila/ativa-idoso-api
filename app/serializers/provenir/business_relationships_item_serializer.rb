# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships_items
#
#  id                                :bigint           not null, primary key
#  additional_details                :string
#  creation_date                     :datetime
#  last_update_date                  :datetime
#  related_entity_name               :string
#  related_entity_tax_id_country     :string
#  related_entity_tax_id_number      :string
#  related_entity_tax_id_type        :string
#  relationship_end_date             :datetime
#  relationship_level                :string
#  relationship_name                 :string
#  relationship_start_date           :datetime
#  relationship_subtype              :string
#  relationship_type                 :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  provenir_business_relationship_id :bigint           not null
#
# Indexes
#
#  index_provenir_bus_rel_items_business_relationship_id  (provenir_business_relationship_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_business_relationship_id => provenir_business_relationships.id)
#
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
