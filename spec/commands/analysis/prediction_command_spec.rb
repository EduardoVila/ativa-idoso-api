# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::PredictionCommand, type: :command do
  describe '#call' do
    let(:analysis_item) { create :analysis_item, :wip }
    let(:analysis_prediction) { create :analysis_prediction }
    let(:analysis_token) { create :analysis_token }
    let(:integrator) { instance_double(Analysis::PredictionIntegrator) }
    let(:success_hash) do
      { status: 'success', approved: true, disapproval_situation: nil }
    end
    let(:failure_hash) do
      { status: 'failure', approved: false, disapproval_situation: nil }
    end

    before do
      allow(Analysis::PredictionIntegrator).to receive(:new)
        .and_return(integrator)

      allow(integrator).to receive(:create_resource).with(analysis_item)
        .and_return(success_hash)

      allow(Analysis::TokenService).to receive(:call).and_return(analysis_token)
    end

    it 'calls the Analysis::PredictionIntegrator' do
      described_class.call(analysis_item)

      expect(integrator).to have_received(:create_resource).with(analysis_item)
    end

    it 'returns a Prediction object' do
      expect(described_class.call(analysis_item)).to eq(success_hash)
    end

    context 'when analysis_item has error status' do
      before do
        allow(analysis_item).to receive(:alpop_prediction_error_status?)
          .and_return(true)

        allow(analysis_item).to receive(:update)
      end

      it 'changes analysis_item error_status to none' do
        described_class.call(analysis_item)
        expect(analysis_item).to have_received(:update)
          .with(error_status: :none)
      end
    end

    context 'when an error occurs during prediction' do
      before do
        allow(integrator).to receive(:create_resource).with(analysis_item)
          .and_raise(StandardError)

        allow(analysis_item).to receive(:update)
      end

      it 'updates analysis_item error_status to alpop_prediction' do
        described_class.call(analysis_item)
        expect(analysis_item).to have_received(:update)
          .with(error_status: :alpop_prediction)
      end

      it 'returns a failure hash' do
        expect(described_class.call(analysis_item)).to eq(failure_hash)
      end
    end
  end
end
