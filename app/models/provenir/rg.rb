# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :bigint           not null, primary key
#  creation_date                             :datetime
#  document_last4_digits                     :string
#  last_update_date                          :datetime
#  number                                    :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  provenir_extended_document_information_id :bigint           not null
#
# Indexes
#
#  index_big_data_rg_extended_document_information_id  (provenir_extended_document_information_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_extended_document_information_id => provenir_extended_document_informations.id)
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
