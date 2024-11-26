# frozen_string_literal: true

require_relative '../application_serializer'

module Serasa
  class FintechReportSerializer < ApplicationSerializer
    attributes :id, :created_at, :debits, :notaries

    def debits
      return [] if negative_data.blank?

      debits_data.map(&:serialize_record)
    end

    def notaries
      return [] if negative_data.blank?

      notaries_data.map(&:serialize_record)
    end

    private

    def negative_data
      object.negative_data
    end

    def debits_data
      negative_data.debits
    end

    def notaries_data
      negative_data.notaries
    end
  end
end
