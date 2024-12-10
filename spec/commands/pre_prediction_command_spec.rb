# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PrePredictionCommand, type: :command do
  subject { described_class.new(analysis_item) }

  let(:analysis_item) { create :analysis_item }

  describe '#call' do
    let(:analysis_item) { create :analysis_item, :wip }

    context 'when result is approved' do
      let(:approved_data_hash) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      before do
        allow(Validators::PrePredictionValidatorService)
          .to receive(:call).and_return(approved_data_hash)
      end

      it 'returns approved hash data' do
        expect(subject.call).to eq(approved_data_hash)
      end
    end

    context 'when result is not approved' do
      let(:disapproval_situation) do
        %i[reproved_by_obit_indication reproved_by_relative reproved_by_trial
           reproved_by_age_and_income blocked_negativity exceeded_debits
           reproved_by_recent_debit reproved_by_protested_title]
      end

      let(:reproved_data_hash) do
        {
          status: 'success',
          approved: false,
          disapproval_situation:
        }
      end

      before do
        allow(Validators::PrePredictionValidatorService)
          .to receive(:call).and_return(reproved_data_hash)
      end

      it 'returns reproved data hash' do
        expect(subject.call).to eq(reproved_data_hash)
      end
    end
  end
end
