# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships
#
#  id                        :bigint           not null, primary key
#  total_relationships       :integer
#  total_ownerships          :integer
#  total_employments         :integer
#  total_partners            :integer
#  total_clients             :integer
#  total_suppliers           :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module Provenir
  class BusinessRelationship < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :business_relationship

    has_many :business_relationships_items,
             class_name: 'Provenir::BusinessRelationshipsItem',
             foreign_key: 'provenir_business_relationship_id',
             inverse_of: :business_relationship,
             dependent: :destroy

    accepts_nested_attributes_for :business_relationships_items

    alias_attribute :business_relationships_array, :business_relationships_items

    def business_relationships_array_attributes=(params)
      self.business_relationships_items_attributes = params
    end
  end
end
