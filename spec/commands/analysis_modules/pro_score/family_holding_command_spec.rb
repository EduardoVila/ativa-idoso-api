# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe ProScore::FamilyHoldingCommand, type: :command do
  subject do
    described_class.new(analysis_item)
  end

  let(:analysis_item) { create :analysis_item }

  describe '#call' do
    let(:family_holding_integrator) do
      instance_double(ProScore::FamilyHoldingIntegrator)
    end

    let!(:report) { create :pro_score_report, analysis_item: }

    context 'when already has family_holding' do
      let!(:family_holding) do
        create(:pro_score_family_holding, report:)
      end

      before do
        report.update(performed_searches: ['family_holding'])
      end

      context 'when the score is reproved' do
        context 'when score reproved belong to current score_report' do
          let(:analysis_item1) do
            create(
              :analysis_item,
              report: analysis_item.report,
              cpf: CPF::Formatter.format(family_holding.cpf_do_parente),
              status: :done
            )
          end

          before do
            create :analysis_prediction, item: analysis_item1, approved: false
          end

          it 'does not creates a prediction' do
            expect { subject.call }.not_to change(Analysis::Prediction, :count)
          end
        end

        context 'when score reproved is from other score_report' do
          let(:analysis_item1) do
            create(
              :analysis_item,
              cpf: CPF::Formatter.format(family_holding.cpf_do_parente),
              status: :done
            )
          end

          before do
            create :analysis_prediction, item: analysis_item1, approved: false
          end

          it 'creates a prediction' do
            expect do
              subject.call
            end.to change(Analysis::Prediction, :count).by(1)
          end
        end
      end

      context 'when the score is approved' do
        it 'does not create a prediction' do
          expect { subject.call }.not_to change(Analysis::Prediction, :count)
        end
      end
    end

    context 'when has not family_holding' do
      context 'when integrator performs correctly' do
        before do
          allow(ProScore::FamilyHoldingIntegrator).to receive(:new)
            .and_return(family_holding_integrator)
          allow(family_holding_integrator).to receive(:load_data)
        end

        it 'calls family_holdings integrator' do
          subject.call

          expect(family_holding_integrator).to have_received(:load_data)
        end
      end

      context 'when it has error status' do
        let!(:analysis_item) do
          create :analysis_item, error_status: 'pro_score_family_holdings'
        end

        before do
          allow(ProScore::FamilyHoldingIntegrator).to receive(:new)
            .and_return(family_holding_integrator)
          allow(family_holding_integrator).to receive(:load_data)
            .and_return([])
        end

        it 'sets the error status as none' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('pro_score_family_holdings').to('none')
        end
      end

      context 'when integrator performs with error' do
        let!(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(ProScore::FamilyHoldingIntegrator).to receive(:new)
            .and_return(family_holding_integrator)
          allow(family_holding_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'updates score to error' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('none').to('pro_score_family_holdings')
        end
      end
    end
  end
end
