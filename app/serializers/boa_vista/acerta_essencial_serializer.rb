# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :bigint           not null, primary key
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  consumer_type :string
#  consumer_id   :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
