# frozen_string_literal: true

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
