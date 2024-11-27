# frozen_string_literal: true

require_relative '../application_serializer'

module ProScore
  class ProprableProfessionSerializer < ApplicationSerializer
    attributes :id, :numero_plugin, :codigo, :titulo
  end
end
