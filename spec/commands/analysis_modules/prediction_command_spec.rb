# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AnalysisModules::PredictionCommand, type: :command do
  describe '#call' do
    let(:analysis_item) { create :analysis_item, :wip }
    let(:analysis_prediction) { create :analysis_prediction }
    let(:analysis_token) { create :analysis_token }
    let(:integrator) { instance_double(Analysis::PredictionIntegrator) }

    before do
      allow(Analysis::PredictionIntegrator).to receive(:new)
        .and_return(integrator)

      allow(integrator).to receive(:create_resource).with(analysis_item)
        .and_return(analysis_prediction)

      allow(Analysis::TokenService).to receive(:call).and_return(analysis_token)
    end

    it 'calls the Analysis::PredictionIntegrator' do
      described_class.new.call(analysis_item)

      expect(integrator).to have_received(:create_resource).with(analysis_item)
    end

    it 'returns a Prediction object' do
      expect(described_class.new.call(analysis_item))
        .to be_a(Analysis::Prediction)
    end
  end
end
