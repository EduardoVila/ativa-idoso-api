# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_personal_relationships
#
#  id                            :bigint           not null, primary key
#  creation_date                 :datetime
#  last_update_date              :datetime
#  related_entity_name           :string
#  related_entity_tax_id_country :string
#  related_entity_tax_id_number  :string
#  related_entity_tax_id_type    :string
#  relationship_end_date         :datetime
#  relationship_level            :string
#  relationship_start_date       :datetime
#  relationship_type             :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  provenir_related_person_id    :bigint           not null
#
# Indexes
#
#  index_provenir_personal_relationship_related_person_id  (provenir_related_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_related_person_id => provenir_related_people.id)
#
require_relative '../application_serializer'

module Provenir
  class PersonalRelationshipSerializer < ApplicationSerializer
    attributes :id, :cpf, :name, :degree_of_kinship, :analysis_report_id

    delegate :id, to: :analysis_report, prefix: true, allow_nil: true

    def cpf
      CPF::Formatter.format(object.related_entity_tax_id_number)
    end

    def name
      object.related_entity_name
    end

    def degree_of_kinship
      object.relationship_type
    end

    private

    def analysis_item
      ::Analysis::Item.find_by(cpf: cpf)
    end

    def analysis_report
      analysis_item&.analysis_report
    end
  end
end
