# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_facts
#
#  id                       :uuid             not null, primary key
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module Serasa
  class Fact < ApplicationRecord
    belongs_to :fintech_report,
               class_name: 'Serasa::FintechReport',
               foreign_key: 'serasa_fintech_report_id',
               inverse_of: :fact

    has_one :inquiry,
            class_name: 'Serasa::Inquiry',
            dependent: :destroy,
            foreign_key: 'serasa_fact_id',
            inverse_of: :fact

    has_one :stolen_document,
            class_name: 'Serasa::StolenDocument',
            dependent: :destroy,
            foreign_key: 'serasa_fact_id',
            inverse_of: :fact

    accepts_nested_attributes_for :inquiry
    accepts_nested_attributes_for :stolen_document

    alias_attribute :stolen_documents, :stolen_document

    # Adds suport for creating stolen_document associations via `stolen_documents_attributes`
    # This is in addition to `stolen_document_attributes=value` method provided by
    # `accepts_nested_attributes_for :stolen_document`
    # Required to import data from Serasa API
    def stolen_documents_attributes=(params)
      self.stolen_document_attributes = params
    end
  end
end
