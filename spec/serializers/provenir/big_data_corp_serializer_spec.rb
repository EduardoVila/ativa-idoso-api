# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::BigDataCorpSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:big_data_corp) { build :provenir_big_data_corp }
  let(:serializer) { described_class.new big_data_corp }

  it { is_expected.to serialize_attribute(:id).from(big_data_corp) }

  describe 'custom method' do
    describe '#business_relationship' do
      subject { serialized[:business_relationship] }

      let!(:business_relationship) do
        create :provenir_business_relationship, big_data_corp:
      end
      let(:serialized_business_relationship) do
        business_relationship.serialize_record
      end

      it 'returns the resource serialized' do
        expect(subject).to eq serialized_business_relationship
      end
    end

    describe '#financial_datum' do
      subject { serialized[:financial_datum] }

      let!(:financial_datum) do
        create :provenir_financial_datum, big_data_corp:
      end
      let(:serialized_financial_datum) do
        financial_datum.serialize_record
      end

      it 'returns the resource serialized' do
        expect(subject).to eq serialized_financial_datum
      end
    end

    describe '#related_person' do
      subject { serialized[:related_person] }

      let!(:related_person) do
        create :provenir_related_person, big_data_corp:
      end
      let(:serialized_related_person) do
        related_person.serialize_record
      end

      it 'returns the resource serialized' do
        expect(subject).to eq serialized_related_person
      end
    end

    describe '#process' do
      subject { serialized[:process] }

      let!(:process) do
        create :provenir_process, big_data_corp:
      end
      let(:serialized_process) do
        process.serialize_record
      end

      it 'returns the resource serialized' do
        expect(subject).to eq serialized_process
      end
    end
  end
end
