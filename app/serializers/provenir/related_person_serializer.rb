# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :bigint           not null, primary key
#  total_college_class       :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_neighbors           :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_relatives           :integer
#  total_spouses             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_related_person_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
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
