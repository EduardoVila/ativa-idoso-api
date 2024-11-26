# frozen_string_literal: true

require_relative '../application_serializer'

module ProScore
  class PresumedIncomeSerializer < ApplicationSerializer
    attributes :id, :value, :created_at

    def value
      object.valor_da_renda_presumida
    end
  end
end
