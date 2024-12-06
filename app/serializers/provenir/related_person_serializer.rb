# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :bigint           not null, primary key
#  total_relationships       :integer
#  total_relatives           :integer
#  total_neighbors           :integer
#  total_spouses             :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_partners            :integer
#  total_college_class       :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
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
