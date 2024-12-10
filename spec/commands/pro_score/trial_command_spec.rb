# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe ProScore::TrialCommand, type: :command do
  subject do
    described_class.new(analysis_item)
  end

  let(:analysis_item) { create :analysis_item }

  describe '#call' do
    let(:trial_integrator) do
      instance_double(ProScore::TrialIntegrator)
    end

    let!(:report) { create :pro_score_report, analysis_item: }

    context 'when already has trial' do
      before do
        allow(ProScore::TrialIntegrator).to receive(:new)
          .and_return trial_integrator

        allow(trial_integrator).to receive(:load_data)

        report.update(performed_searches: ['trial'])
      end

      xcontext 'when the score is reproved' do # rubocop:disable RSpec/PendingWithoutReason
        before do
          create :pro_score_trial, report:
        end

        it 'creates a prediction' do
          expect { subject.call }.to change(Prediction, :count).by(1)
        end
      end

      xcontext 'when the score is approved' do # rubocop:disable RSpec/PendingWithoutReason
        it 'does not create a prediction' do
          expect { subject.call }.not_to change(Prediction, :count)
        end
      end
    end

    context 'when has not trial' do
      context 'when integrator performs correctly' do
        before do
          allow(ProScore::TrialIntegrator).to receive(:new)
            .and_return trial_integrator

          allow(trial_integrator).to receive(:load_data)
        end

        it 'calls trials integrator' do
          subject.call

          expect(trial_integrator).to have_received(:load_data).once
        end
      end

      context 'when it has error status' do
        before do
          analysis_item.update(error_status: 'pro_score_trials')

          allow(ProScore::TrialIntegrator).to receive(:new)
            .and_return trial_integrator

          allow(trial_integrator).to receive(:load_data)
            .and_return([])
        end

        it 'sets the error status as none' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('pro_score_trials').to('none')
        end
      end

      context 'when integrator performs with error' do
        let(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(ProScore::TrialIntegrator).to receive(:new)
            .and_return trial_integrator

          allow(trial_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'updates score to error' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('none').to('pro_score_trials')
        end
      end
    end
  end
end
