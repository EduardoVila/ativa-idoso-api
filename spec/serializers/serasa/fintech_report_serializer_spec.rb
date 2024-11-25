# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::FintechReportSerializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:fintech_report) { create :serasa_fintech_report }
  let(:serializer) { described_class.new fintech_report }

  it do
    expect(subject).to serialize_attribute(:id).from(fintech_report)
    expect(subject).to serialize_attribute(:created_at).from(fintech_report)
  end

  describe 'custom attributes' do
    let(:fintech_report) { create :serasa_fintech_report }
    let(:negative_data) do
      create :serasa_negative_data, fintech_report:
    end
    let!(:pefin) do
      create :serasa_pefin, negative_data:, items: []
    end
    let!(:refin) do
      create :serasa_refin, negative_data:, items: []
    end
    let!(:notary) do
      create :serasa_notary, negative_data:, items: []
    end

    describe 'debits' do
      context 'when there are not debits' do
        subject { serialized[:debits] }

        it 'returns an empty array' do
          expect(subject).to eq []
        end
      end

      context 'when there are debits' do
        subject { serialized[:debits] }

        let!(:pefin_item) { create :serasa_negative_item, owner: pefin }
        let!(:refin_item) { create :serasa_negative_item, owner: refin }

        before do
          pefin.reload
          refin.reload
        end

        it 'returns all pefins and refins serialized' do
          expect(subject).to match_array(
            [pefin_item, refin_item].map(&:serialize_record)
          )
        end
      end
    end

    describe 'notaries' do
      context 'when there are not debits' do
        subject { serialized[:notaries] }

        it 'returns an empty array' do
          expect(subject).to eq []
        end
      end

      context 'when there are protests' do
        subject { serialized[:notaries] }

        let!(:notary_item) { create :serasa_notary_item, notary: }

        before do
          notary.reload
        end

        it 'returns all protests serialized' do
          expect(subject).to match_array(
            [notary_item].map(&:serialize_record)
          )
        end
      end
    end
  end
end
