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
require 'spec_helper'

RSpec.describe Provenir::BusinessRelationshipSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:business_relationship) { build :provenir_business_relationship }
  let(:serializer) { described_class.new business_relationship }

  it { is_expected.to serialize_attribute(:id).from(business_relationship) }

  it {
    expect(subject).to serialize_attribute(:total_relationships)
      .from(business_relationship)
  }

  it {
    expect(subject).to serialize_attribute(:total_ownerships)
      .from(business_relationship)
  }

  it {
    expect(subject).to serialize_attribute(:total_employments)
      .from(business_relationship)
  }

  it {
    expect(subject).to serialize_attribute(:total_partners)
      .from(business_relationship)
  }

  it {
    expect(subject).to serialize_attribute(:total_clients)
      .from(business_relationship)
  }

  it {
    expect(subject).to serialize_attribute(:total_suppliers)
      .from(business_relationship)
  }

  describe 'custom methods' do
    describe '#items' do
      subject(:items) { serialized[:items] }

      let(:business_relationship) { create :provenir_business_relationship }
      let!(:business_relationships_item) do
        create(
          :provenir_business_relationships_item,
          business_relationship:
        )
      end
      let(:serializer) { described_class.new business_relationship }
      let(:serialized) { serializer.serializable_hash }
      let(:serialized_business_relationships_item) do
        business_relationships_item.serialize_record(
          with: Provenir::BusinessRelationshipsItemSerializer
        )
      end

      it 'returns the collection serialized correctly' do
        expect(subject).to contain_exactly(
          serialized_business_relationships_item
        )
      end
    end
  end
end
