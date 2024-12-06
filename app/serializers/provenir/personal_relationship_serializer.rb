# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_personal_relationships
#
#  id                            :bigint           not null, primary key
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
#  provenir_related_person_id    :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
