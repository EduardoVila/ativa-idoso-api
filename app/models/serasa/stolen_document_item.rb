# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :bigint           not null, primary key
#  detailed_reason           :string
#  document_number           :string
#  document_type             :string
#  inclusion_date            :datetime
#  issuing_authority         :string
#  occurrence_date           :date
#  occurrence_state          :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  serasa_stolen_document_id :bigint           not null
#
# Indexes
#
#  idx_on_serasa_stolen_document_id_e5dbecfd0e  (serasa_stolen_document_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_stolen_document_id => serasa_stolen_documents.id)
#
module Serasa
  class StolenDocumentItem < ApplicationRecord
    belongs_to :stolen_document,
               class_name: 'Serasa::StolenDocument',
               foreign_key: 'serasa_stolen_document_id',
               inverse_of: :items

    has_one :phone,
            class_name: 'Serasa::Phone',
            as: :owner,
            dependent: :destroy,
            inverse_of: :owner

    accepts_nested_attributes_for :phone

    # Adds suport for creating phone associations via `phone_number_attributes`
    # This is in addition to `phone_attributes=value` method provided by
    # `accepts_nested_attributes_for :phone`
    # Required to import data from Serasa API
    def phone_number_attributes=(params)
      self.phone_attributes = params
    end
  end
end
