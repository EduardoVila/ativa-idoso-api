# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpfcnpj             :string
#  razao_social        :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require_relative '../application_serializer'

module ProScore
  class CommercialRelationSerializer < ApplicationSerializer
    attributes :id, :cpfcnpj, :corporate_name, :created_at

    def corporate_name
      object.razao_social
    end
  end
end
