# frozen_string_literal: true

require_relative '../application_serializer'

module Analysis
  class PredictionSerializer < ApplicationSerializer
    attributes :id, :label, :fee, :approved, :created_at
  end
end
