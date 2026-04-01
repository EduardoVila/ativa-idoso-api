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

      context 'when client is under minimum age' do
        let(:analysis_item) do
          create :analysis_item, status: :todo, name: nil
        end
        let(:boa_vista_cadastral) do
          create :boa_vista_cadastral, consumer: analysis_item
        end
        let(:basic_registration) do
          create(
            :boa_vista_basic_registration,
            boa_vista_cadastral: boa_vista_cadastral,
            birth_date: 15.years.ago.to_date.to_s
          )
        end

        before do
          basic_registration
          allow(analysis_item).to(
            receive_messages(
              error_status: 'none', boa_vista_cadastral_name: 'Test Name'
            )
          )
        end

        it 'sets status to done and reproved_by_minimum_age' do
          item_command.call

          expect(analysis_item.reload.status).to eq('done')
          expect(analysis_item.disapproval_situation)
            .to eq('reproved_by_minimum_age')
        end

        it 'does not call analyze_item_step_by_step' do
          item_command.call

          expect(Invoker).not_to have_received(:execute)
            .with(:analysis_step_by_step_command, analysis_item)
        end

        it 'calls sync_analysis_report' do
          item_command.call

          expect(Invoker).to have_received(:execute)
            .with(:analysis_report_sync_command, analysis_report)
        end
      end

      context 'when client is at minimum age (18 years old)' do
        let(:analysis_item) do
          create :analysis_item, status: :todo, name: nil
        end
        let(:boa_vista_cadastral) do
          create :boa_vista_cadastral, consumer: analysis_item
        end
        let(:basic_registration) do
          create(
            :boa_vista_basic_registration,
            boa_vista_cadastral: boa_vista_cadastral,
            birth_date: 18.years.ago.to_date.to_s
          )
        end

        before do
          basic_registration
          allow(analysis_item).to(
            receive_messages(
              error_status: 'none', boa_vista_cadastral_name: 'Test Name'
            )
          )
        end

        it 'continues to step by step analysis' do
          item_command.call

          expect(Invoker).to have_received(:execute)
            .with(:analysis_step_by_step_command, analysis_item)
        end

        it 'does not set reproved_by_minimum_age' do
          item_command.call

          expect(analysis_item.reload.disapproval_situation)
            .not_to eq('reproved_by_minimum_age')
        end
      end

      context 'when birth_date is nil' do
        let(:analysis_item) do
          create :analysis_item, status: :todo, name: nil
        end
        let(:boa_vista_cadastral) do
          create :boa_vista_cadastral, consumer: analysis_item
        end
        let(:basic_registration) do
          create(
            :boa_vista_basic_registration,
            boa_vista_cadastral: boa_vista_cadastral,
            birth_date: nil
          )
        end

        before do
          basic_registration
          allow(analysis_item).to(
            receive_messages(
              error_status: 'none', boa_vista_cadastral_name: 'Test Name'
            )
          )
        end

        it 'continues to step by step analysis' do
          item_command.call

          expect(Invoker).to have_received(:execute)
            .with(:analysis_step_by_step_command, analysis_item)
        end

        it 'does not block the analysis' do
          item_command.call

          expect(analysis_item.reload.disapproval_situation)
            .not_to eq('reproved_by_minimum_age')
        end
      end
    end
  end
end
