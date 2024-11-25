# frozen_string_literal: true

require_relative '../application_serializer'

module Provenir
  class ProcessSerializer < ApplicationSerializer
    attributes :id, :lawsuits_total, :lawsuits

    def lawsuits
      object.lawsuits.map do |lawsuit|
        lawsuit.serialize_record(with: Provenir::LawsuitSerializer)
      end
    end
  end
end
