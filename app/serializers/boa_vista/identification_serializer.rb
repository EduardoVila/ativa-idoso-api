# frozen_string_literal: true

require_relative '../application_serializer'

module BoaVista
  class IdentificationSerializer < ApplicationSerializer
    attributes :id, :name, :birth_date
  end
end
