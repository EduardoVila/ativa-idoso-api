# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :bigint           not null, primary key
#  approved              :boolean
#  cpfs                  :string           is an Array
#  disapproval_situation :integer
#  fee                   :float
#  payload               :string
#  prediction_model_name :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  api_client_id         :bigint           not null
#
# Indexes
#
#  index_analysis_reports_on_api_client_id  (api_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
#
require 'spec_helper'

RSpec.describe Analysis::ReportSerializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:analysis_report) { create :analysis_report, status: :todo }
  let(:serializer) { described_class.new analysis_report }

  it { is_expected.to serialize_attribute(:id).from(analysis_report) }
  it { is_expected.to serialize_attribute(:status).from(analysis_report) }
  it { is_expected.to serialize_attribute(:created_at).from(analysis_report) }

  describe 'custom attributes' do
    describe '#result' do
      context 'when the status is not done' do
        subject { serialized[:result] }

        it { is_expected.to eq({}) }
      end

      context 'when the status is done' do
        let(:serializer) { described_class.new analysis_report }
        let(:serialized) { serializer.as_json(root: false) }
        let(:result) { serialized[:result] }
        let!(:analysis_item) do
          create :analysis_item, report: analysis_report, status: :done
        end

        context 'when the analysis_report is approved' do
          let(:analysis_report) do
            create :analysis_report, approved: true, fee: 6.5, status: :done
          end

          it 'returns the result correctly' do
            expect(result).to eq(
              {
                approved: true,
                disapproval_situation: nil,
                value: 6.5
              }
            )
          end
        end

        context 'when the analysis_report is unapproved' do
          let(:analysis_report) do
            create :analysis_report, approved: false, status: :done, fee: nil
          end

          it 'returns the result correctly' do
            expect(result).to eq(
              {
                approved: false,
                disapproval_situation: nil,
                value: nil
              }
            )
          end
        end
      end
    end

    describe '#valid_until' do
      subject { serialized[:valid_until] }

      it { is_expected.to eq(analysis_report.created_at + 30.days) }
    end

    describe '#analysis_items' do
      subject(:analysis_items) { serialized[:items] }

      let(:analysis_report) { create :analysis_report, status: :done }
      let!(:analysis_item) { create :analysis_item, report: analysis_report }
      let(:serializer) { described_class.new analysis_report }
      let(:serialized) { serializer.as_json(root: false) }
      let(:serialized_analysis_item) do
        analysis_item.serialize_record(with: Analysis::ItemSerializer)
      end

      it 'returns the collection ordered correctly' do
        expect(analysis_items).to eq([serialized_analysis_item])
      end
    end
  end
end
