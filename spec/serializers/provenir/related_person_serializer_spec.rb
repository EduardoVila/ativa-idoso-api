# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :bigint           not null, primary key
#  total_college_class       :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_neighbors           :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_relatives           :integer
#  total_spouses             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_related_person_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
require 'spec_helper'

RSpec.describe Provenir::RelatedPersonSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:related_person) { build :provenir_related_person }
  let(:serializer) { described_class.new related_person }

  it { is_expected.to serialize_attribute(:id).from(related_person) }

  it do
    expect(subject).to serialize_attribute(:total_relationships)
      .from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_neighbors)
      .from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_coworkers)
      .from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_spouses).from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_household)
      .from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_partners).from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_college_class)
      .from(related_person)
  end

  it do
    expect(subject).to serialize_attribute(:total_relatives)
      .from(related_person)
  end

  describe 'custom method' do
    describe '#personal_relationships' do
      subject(:personal_relationships) { serialized[:personal_relationships] }

      let(:related_person) { create :provenir_related_person }
      let!(:personal_relationship) do
        create :provenir_personal_relationship, related_person:
      end
      let(:serializer) { described_class.new related_person }
      let(:serialized) { serializer.serializable_hash }
      let(:serialized_personal_relationship) do
        personal_relationship.serialize_record(
          with: Provenir::PersonalRelationshipSerializer
        )
      end

      it 'returns the collection serialized correctly' do
        expect(personal_relationships).to contain_exactly(
          serialized_personal_relationship
        )
      end
    end
  end
end
