# frozen_string_literal: true

require_relative '../application_serializer'

module BoaVista
  class AcertaEssencialSerializer < ApplicationSerializer
    attributes :id, :cpf, :identification

    # custom attributes
    # ----
    attributes :debits_count, :debits_value, :protested_titles_count,
               :protested_titles_value, :presumed_income, :debits,
               :protested_titles

    def cpf
      CPF::Formatter.format object.cpf
    end

    def identification
      object.identification&.serialize_record
    end

    def debits
      object.debits&.map(&:serialize_record)
    end

    def protested_titles
      object.protested_titles&.map(&:serialize_record)
    end

    def debits_count
      object.debits.count
    end

    def debits_value
      object.debits_total_value
    end

    def protested_titles_count
      object.protested_titles.count
    end

    def protested_titles_value
      object.protested_titles_total_value
    end

    delegate :presumed_income, to: :object
  end
end
