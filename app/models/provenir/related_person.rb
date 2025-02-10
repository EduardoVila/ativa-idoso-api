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
module Provenir
  class RelatedPerson < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :related_person

    has_many :personal_relationships,
             class_name: 'Provenir::PersonalRelationship',
             foreign_key: 'provenir_related_person_id',
             inverse_of: :related_person,
             dependent: :destroy

    validates :provenir_big_data_corp_id, uniqueness: true

    accepts_nested_attributes_for :personal_relationships
  end
end
