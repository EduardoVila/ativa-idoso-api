# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :bigint           not null, primary key
#  cpfcnpj             :string
#  numero_plugin       :string
#  razao_social        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_commercial_relations_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
