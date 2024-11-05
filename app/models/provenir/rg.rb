# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :bigint           not null, primary key
#  document_last4_digits                     :string
#  creation_date                             :datetime
#  last_update_date                          :datetime
#  provenir_extended_document_information_id :bigint           not null
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  number                                    :string
#
module Provenir
  class Rg < ApplicationRecord
    belongs_to :extended_document_information,
               class_name: 'Provenir::ExtendedDocumentInformation',
               foreign_key: 'provenir_extended_document_information_id',
               inverse_of: :rg

    has_one :source,
            class_name: 'Provenir::Source',
            foreign_key: 'provenir_rg_id',
            inverse_of: :rg,
            dependent: :destroy

    accepts_nested_attributes_for :source

    alias_attribute :sources, :source

    def sources_attributes=(params)
      self.source_attributes = params
    end
  end
end
