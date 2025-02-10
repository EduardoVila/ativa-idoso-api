# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships
#
#  id                        :bigint           not null, primary key
#  total_clients             :integer
#  total_employments         :integer
#  total_ownerships          :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_suppliers           :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_business_relationship_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
module Provenir
  class BusinessRelationship < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      business_relationships_array: :business_relationships_items
    }.freeze

    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :business_relationship

    has_many :business_relationships_items,
             class_name: 'Provenir::BusinessRelationshipsItem',
             foreign_key: 'provenir_business_relationship_id',
             inverse_of: :business_relationship,
             dependent: :destroy

    validates :provenir_big_data_corp_id, uniqueness: true

    accepts_nested_attributes_for :business_relationships_items

    alias business_relationships_array business_relationships_items

    def business_relationships_array_attributes=(params)
      self.business_relationships_items_attributes = params
    end
  end
end
