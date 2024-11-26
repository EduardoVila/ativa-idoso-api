# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class RelatedPersonSerializer < ApplicationSerializer
    attributes :id, :total_relationships, :total_relatives, :total_neighbors,
               :total_spouses, :total_coworkers, :total_household,
               :total_partners, :total_college_class, :personal_relationships

    def personal_relationships
      object.personal_relationships.map do |personal_relationship|
        personal_relationship.serialize_record(
          with: Provenir::PersonalRelationshipSerializer
        )
      end
    end
  end
end
