# frozen_string_literal: true

require_relative '../application_serializer'

module ProScore
  class FamilyHoldingSerializer < ApplicationSerializer
    attributes :id, :cpf, :name, :degree_of_kinship, :created_at,
               :analysis_report_id

    delegate :id, to: :analysis_report, prefix: true, allow_nil: true

    def cpf
      CPF::Formatter.format object.cpf_do_parente
    end

    def name
      object.nome_do_parente
    end

    def degree_of_kinship
      object.grau_de_parentesco
    end

    private

    def analysis_item
      ::Analysis::Item.find_by(cpf:)
    end

    def analysis_report
      analysis_item&.analysis_report
    end
  end
end
