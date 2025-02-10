# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_document_informations
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_extended_document_information_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
module Provenir
  class ExtendedDocumentInformation < ApplicationRecord
    belongs_to :basic_datum,
               class_name: 'Provenir::BasicDatum',
               foreign_key: 'provenir_basic_datum_id',
               inverse_of: :extended_document_information

    has_one :rg,
            class_name: 'Provenir::Rg',
            foreign_key: 'provenir_extended_document_information_id',
            inverse_of: :extended_document_information,
            dependent: :destroy

    accepts_nested_attributes_for :rg

    validates :provenir_basic_datum_id, uniqueness: true
  end
end
