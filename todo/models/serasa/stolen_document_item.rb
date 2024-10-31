# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :bigint           not null, primary key
#  occurrence_date           :date
#  inclusion_date            :datetime
#  document_type             :string
#  document_number           :string
#  issuing_authority         :string
#  detailed_reason           :string
#  occurrence_state          :string
#  serasa_stolen_document_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
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
