# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe ProScore::PresumedIncomeCommand,
               type: :command do
  subject do
    described_class.new(analysis_item)
  end

  let(:analysis_item) { create :analysis_item }

  describe '#call' do
    let(:presumed_income_integrator) do
      instance_double(ProScore::PresumedIncomeIntegrator)
    end

    let!(:report) { create :pro_score_report, analysis_item: }

    context 'when already has presumed_income' do
      before do
        allow(ProScore::PresumedIncomeIntegrator).to receive(:new)
          .and_return presumed_income_integrator

        allow(presumed_income_integrator).to receive(:load_data)

        report.update(performed_searches: ['presumed_income'])
      end

      it 'does not call presumed income integrator' do
        subject.call

        expect(presumed_income_integrator).not_to have_received(:load_data)
      end

      xcontext 'when the score is reproved' do # rubocop:disable RSpec/PendingWithoutReason
        before do
          create(
            :pro_score_presumed_income,
            report:,
            valor_da_renda_presumida: '800,00'
          )
        end

        it 'creates a prediction' do
          expect { subject.call }.to change(Prediction, :count).by(1)
        end

        it 'updates score to insufficient_income' do
          subject.call

          expect(analysis_item.disapproval_situation)
            .to eq('insufficient_income')
        end
      end

      xcontext 'when the score is approved' do # rubocop:disable RSpec/PendingWithoutReason
        before do
          create(
            :pro_score_presumed_income,
            report:,
            valor_da_renda_presumida: '1200,00'
          )
        end

        it 'does not create a prediction' do
          expect { subject.call }.not_to change(Prediction, :count)
        end
      end
    end

    context 'when has not presumed_income' do
      context 'when integrator performs correctly' do
        before do
          allow(ProScore::PresumedIncomeIntegrator).to receive(:new)
            .and_return presumed_income_integrator

          allow(presumed_income_integrator).to receive(:load_data)
        end

        it 'calls presumed_income integrator' do
          subject.call

          expect(presumed_income_integrator).to have_received(:load_data).once
        end
      end

      context 'when it has error status' do
        before do
          analysis_item.update(error_status: 'pro_score_presumed_income')

          allow(ProScore::PresumedIncomeIntegrator).to receive(:new)
            .and_return presumed_income_integrator

          allow(presumed_income_integrator).to receive(:load_data)
            .and_return([])
        end

        it 'sets the error status as none' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('pro_score_presumed_income').to('none')
        end
      end

      context 'when integrator performs with error' do
        let(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(ProScore::PresumedIncomeIntegrator).to receive(:new)
            .and_return presumed_income_integrator

          allow(presumed_income_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'updates score to error' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }.from('none').to('pro_score_presumed_income')
        end
      end
    end
  end
end
