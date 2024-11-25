# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships_items
#
#  id                                :bigint           not null, primary key
#  related_entity_tax_id_number      :string
#  related_entity_tax_id_type        :string
#  related_entity_tax_id_country     :string
#  related_entity_name               :string
#  relationship_name                 :string
#  relationship_type                 :string
#  relationship_subtype              :string
#  relationship_level                :string
#  relationship_start_date           :datetime
#  relationship_end_date             :datetime
#  creation_date                     :datetime
#  last_update_date                  :datetime
#  additional_details                :string
#  provenir_business_relationship_id :bigint           not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
module Provenir
  class BusinessRelationshipsItem < ApplicationRecord
    belongs_to :business_relationship,
               class_name: 'Provenir::BusinessRelationship',
               foreign_key: 'provenir_business_relationship_id',
               inverse_of: :business_relationships_items
  end
end
