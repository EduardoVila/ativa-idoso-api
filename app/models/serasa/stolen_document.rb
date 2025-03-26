# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_documents
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  serasa_fact_id :bigint           not null
#
# Indexes
#
#  index_serasa_stolen_documents_on_serasa_fact_id  (serasa_fact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fact_id => serasa_facts.id)
#
module Serasa
  class StolenDocument < ApplicationRecord
    belongs_to :fact,
               class_name: 'Serasa::Fact',
               foreign_key: 'serasa_fact_id',
               inverse_of: :stolen_document

    has_many :items,
             class_name: 'Serasa::StolenDocumentItem',
             dependent: :destroy,
             foreign_key: 'serasa_stolen_document_id',
             inverse_of: :stolen_document

    has_one :summary,
            class_name: 'Serasa::Summary',
            as: :owner,
            dependent: :destroy,
            inverse_of: :owner

    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :summary

    # Adds suport for creating items associations via `stolen_documents_response_attributes`
    # This is in addition to `items_attributes=value` method provided by
    # `accepts_nested_attributes_for :items`
    # Required to import data from Serasa API
    def stolen_documents_response_attributes=(params)
      self.items_attributes = params
    end
  end
end
