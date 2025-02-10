# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships_items
#
#  id                                :bigint           not null, primary key
#  additional_details                :string
#  creation_date                     :datetime
#  last_update_date                  :datetime
#  related_entity_name               :string
#  related_entity_tax_id_country     :string
#  related_entity_tax_id_number      :string
#  related_entity_tax_id_type        :string
#  relationship_end_date             :datetime
#  relationship_level                :string
#  relationship_name                 :string
#  relationship_start_date           :datetime
#  relationship_subtype              :string
#  relationship_type                 :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  provenir_business_relationship_id :bigint           not null
#
# Indexes
#
#  index_provenir_bus_rel_items_business_relationship_id  (provenir_business_relationship_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_business_relationship_id => provenir_business_relationships.id)
#
require 'spec_helper'

RSpec.describe Provenir::BusinessRelationshipsItem, type: :model do
  describe 'factories' do
    subject { build :provenir_business_relationships_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:business_relationship)
        .class_name('Provenir::BusinessRelationship')
        .with_foreign_key('provenir_business_relationship_id')
        .inverse_of(:business_relationships_items)
    end
  end
end
