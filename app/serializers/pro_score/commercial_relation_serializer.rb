# frozen_string_literal: true

require_relative '../application_serializer'

module ProScore
  class CommercialRelationSerializer < ApplicationSerializer
    attributes :id, :cpfcnpj, :corporate_name, :created_at

    def corporate_name
      object.razao_social
    end
  end
end
