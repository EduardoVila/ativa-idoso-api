# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_personal_relationships
#
#  id                            :uuid             not null, primary key
#  related_entity_tax_id_number  :string
#  related_entity_tax_id_type    :string
#  related_entity_tax_id_country :string
#  related_entity_name           :string
#  relationship_type             :string
#  relationship_level            :string
#  relationship_start_date       :datetime
#  relationship_end_date         :datetime
#  creation_date                 :datetime
#  last_update_date              :datetime
#  provenir_related_person_id    :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module Provenir
  class PersonalRelationship < ApplicationRecord
    belongs_to :related_person,
               class_name: 'Provenir::RelatedPerson',
               foreign_key: 'provenir_related_person_id',
               inverse_of: :personal_relationships
  end
end
