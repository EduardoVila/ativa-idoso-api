# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::ItemRunnerCommand, type: :command do
  describe '#call' do
    subject(:item_command) { described_class.new(analysis_item) }

    let(:analysis_report) { create :analysis_report }

    before do
      allow(analysis_item).to receive(:report).and_return(analysis_report)
      allow(Invoker).to receive(:execute)
    end

    context 'when analysis item status is done or not_found' do
      let(:analysis_item) do
        create :analysis_item, status: %w[done not_found].sample
      end

      it 'calls sync_analysis_report and returns' do
        item_command.call

        expect(Invoker).to have_received(:execute)
          .with(:analysis_report_sync_command, analysis_report)
      end
    end

    context 'when analysis item status is not done or not_found' do
      let(:analysis_item) { create :analysis_item, status: :todo, name: nil }

      it 'updates the analysis item status to wip' do
        item_command.call

        expect(analysis_item.reload.status).to eq('wip')
      end

      context 'when analysis item name is not present' do
        it 'calls run_boa_vista_cadastral' do
          item_command.call

          expect(Invoker).to have_received(:execute)
            .with(:boa_vista_cadastral_command, analysis_item)
        end
      end

      context 'when analysis item name is present' do
        let(:analysis_item) do
          create :analysis_item, status: :todo, name: 'Test Name'
        end

        it 'does not call run_boa_vista_cadastral' do
          item_command.call

          expect(Invoker).not_to have_received(:execute)
            .with(:boa_vista_cadastral_command, analysis_item)
        end
      end

      context 'when boa_vista_error? returns true' do
        before do
          analysis_item.update(error_status: 'boa_vista')
        end

        it 'does not call analyze_item_step_by_step' do
          item_command.call

          expect(Invoker).not_to have_received(:execute)
            .with(:analysis_step_by_step_command, analysis_item)
        end
      end

      context 'when boa_vista_error? returns false' do
        before do
          allow(analysis_item).to receive(:error_status).and_return('none')
        end

        it 'calls analyze_item_step_by_step and sync_analysis_report' do
          item_command.call

          expect(Invoker).to have_received(:execute)
            .with(:analysis_step_by_step_command, analysis_item)
          expect(Invoker).to have_received(:execute)
            .with(:analysis_report_sync_command, analysis_report)
        end
      end
    end
  end
end
