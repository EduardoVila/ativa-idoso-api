# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :bigint           not null, primary key
#  number                                    :string
#  document_last4_digits                     :string
#  creation_date                             :datetime
#  last_update_date                          :datetime
#  provenir_extended_document_information_id :bigint           not null
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
module Provenir
  class Rg < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      sources: :source
    }.freeze

    belongs_to :extended_document_information,
               class_name: 'Provenir::ExtendedDocumentInformation',
               foreign_key: 'provenir_extended_document_information_id',
               inverse_of: :rg

    has_one :source,
            class_name: 'Provenir::Source',
            foreign_key: 'provenir_rg_id',
            inverse_of: :rg,
            dependent: :destroy

    validates :provenir_extended_document_information_id, uniqueness: true

    accepts_nested_attributes_for :source

    alias sources source

    def sources_attributes=(params)
      self.source_attributes = params
    end
  end
end
