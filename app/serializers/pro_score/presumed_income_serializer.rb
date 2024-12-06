# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require_relative '../application_serializer'

module ProScore
  class PresumedIncomeSerializer < ApplicationSerializer
    attributes :id, :value, :created_at

    def value
      object.valor_da_renda_presumida
    end
  end
end
