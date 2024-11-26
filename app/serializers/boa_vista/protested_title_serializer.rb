# frozen_string_literal: true

require_relative '../application_serializer'

module BoaVista
  class ProtestedTitleSerializer < ApplicationSerializer
    attributes :occurrence_type, :occurrence_date, :registry, :value,
               :city, :federative_unit

    def value
      object.value.delete('.').tr(',', '.').to_f
    end

    def occurrence_date
      object.occurrence_date.to_date
    end
  end
end
