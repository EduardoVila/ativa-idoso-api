# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_facts
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_facts_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
module Serasa
  class Fact < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      stolen_documents: :stolen_document
    }.freeze

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

    validates :serasa_fintech_report_id, uniqueness: true

    accepts_nested_attributes_for :inquiry
    accepts_nested_attributes_for :stolen_document

    alias stolen_documents stolen_document

    # Adds suport for creating stolen_document associations via `stolen_documents_attributes`
    # This is in addition to `stolen_document_attributes=value` method provided by
    # `accepts_nested_attributes_for :stolen_document`
    # Required to import data from Serasa API
    def stolen_documents_attributes=(params)
      self.stolen_document_attributes = params
    end
  end
end
