# frozen_string_literal: true

require_relative '../application_serializer'

module BoaVista
  class DebitSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :informant, :segment

    def value
      object.value.delete('.').tr(',', '.').to_f
    end

    def occurrence_date
      object.occurrence_date.to_date
    end
  end
end
