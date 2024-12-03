# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe AnalysisModules::ProScore::BouncedCheckCommand, type: :command do
  describe '#call' do
    let(:command_call) { described_class.new.call(analysis_item) }
    let(:bounced_check_integrator) do
      instance_double(ProScore::BouncedCheckIntegrator)
    end
    let(:analysis_item) { create :analysis_item }
    let(:sucess_hash_data) do
      { status: 'success', approved: true, disapproval_situation: nil }
    end
    let(:failure_hash_data) do
      { status: 'failure', approved: false, disapproval_situation: nil }
    end
    let(:reproved_hash_data) do
      {
        status: 'success',
        approved: false,
        disapproval_situation: :reproved_by_bounced_check
      }
    end

    before do
      allow(ProScore::BouncedCheckIntegrator).to receive(:new)
        .and_return(bounced_check_integrator)

      allow(bounced_check_integrator).to receive(:load_data)
    end

    context 'when it already performed bounced check' do
      let!(:pro_score_report) do
        create :pro_score_report,
               analysis_item:,
               performed_searches: ['bounced_check']
      end

      it 'does not calls bounced check integrator' do
        command_call

        expect(bounced_check_integrator).not_to have_received(:load_data)
      end

      context 'when it have a bounced check' do
        before { create :pro_score_bounced_check, report: pro_score_report }

        it 'returns the correct hash data' do
          expect(command_call).to eq(reproved_hash_data)
        end
      end

      context 'when it does not have a bounced check' do
        it 'returns the correct hash data' do
          expect(command_call).to eq(sucess_hash_data)
        end
      end
    end

    context 'when it has not performed bounced check' do
      context 'when score has error status' do
        before do
          analysis_item.update(error_status: 'pro_score_bounced_checks')
        end

        it 'changes score error_status to none' do
          expect { command_call }.to change(analysis_item, :error_status)
            .from('pro_score_bounced_checks').to('none')
        end
      end

      context 'when integrator performs correctly' do
        let(:pro_score_report) { create :pro_score_report, analysis_item: }

        context 'when it finds a bounced check' do
          before do
            create :pro_score_bounced_check, report: pro_score_report
          end

          it 'returns the correct hash data' do
            expect(command_call).to eq(reproved_hash_data)
          end
        end

        context 'when it does not find a bounced check' do
          it 'returns the correct hash data' do
            expect(command_call).to eq(sucess_hash_data)
          end
        end
      end

      context 'when integrator performs with error' do
        let(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(bounced_check_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'returns the correct hash data' do
          expect(command_call).to eq(failure_hash_data)
        end

        it 'changes score error_status to provenir_big_data_corp' do
          expect { command_call }.to change(analysis_item, :error_status)
            .from('none').to('pro_score_bounced_checks')
        end
      end
    end
  end
end
