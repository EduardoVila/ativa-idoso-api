# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  cpf_do_parente      :string
#  grau_de_parentesco  :string
#  nome_do_parente     :string
#  numero_plugin       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_family_holdings_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
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
