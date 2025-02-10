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
require 'spec_helper'

RSpec.describe Provenir::BusinessRelationship, type: :model do
  describe 'factories' do
    subject { build :provenir_business_relationship }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:business_relationship)
    end

    it do
      expect(subject).to have_many(:business_relationships_items)
        .class_name('Provenir::BusinessRelationshipsItem')
        .with_foreign_key('provenir_business_relationship_id')
        .inverse_of(:business_relationship)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it do
      expect(subject).to accept_nested_attributes_for(
        :business_relationships_items
      )
    end
  end
end
