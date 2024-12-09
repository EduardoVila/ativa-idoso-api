# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::ItemRunnerCommand, type: :command do
  describe '#call' do
    let(:reproved_hash) { { status: 'success', approved: false } }
    let(:approved_hash) do
      {
        status: 'success',
        approved: true,
        disapproval_situation: nil
      }
    end

    context 'when analysis item status is :todo or :wip' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: %i[wip todo].sample,
          disapproval_situation: nil
        )
      end

      it 'updates the analysis item status to :wip' do
        described_class.call(analysis_item)

        expect(analysis_item.reload.status).to eq('wip')
      end
    end

    context 'when analysis item status is :done or :not_found' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: %i[done not_found].sample,
          disapproval_situation: nil
        )
      end

      it 'does not update the analysis item status' do
        described_class.call(analysis_item)

        expect(analysis_item.reload.status).to eq(analysis_item.status)
      end
    end

    context 'when analysis item has error_status as boa_vista' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: :todo,
          error_status: 'boa_vista'
        )
      end

      it 'does not proceed with analyze_cpf' do
        expect_any_instance_of(described_class).not_to receive(:analyze_cpf) # rubocop:disable RSpec/AnyInstance

        described_class.call(analysis_item)
      end
    end

    context 'when analysis item does not have error_status as boa_vista' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: :todo,
          error_status: :none
        )
      end

      it 'proceeds with analyze_cpf' do
        expect_any_instance_of(described_class).to receive(:analyze_cpf) # rubocop:disable RSpec/AnyInstance

        described_class.call(analysis_item)
      end
    end

    context 'when analyzing CPF' do
      let(:analysis_item) do
        create :analysis_item, status: :todo, error_status: :none
      end
      let(:current_analysis) { analysis_item.clone_of || analysis_item }
      let(:steps) { create_list :analysis_step, 3 }

      before do
        allow(Analysis::Step).to receive_message_chain(:enabled, :order) # rubocop:disable RSpec/MessageChain
          .and_return(steps)
        allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
          .to receive(:analysis_modules_runner)
      end

      it 'adds steps to the analysis item' do
        described_class.call(analysis_item)

        expect(analysis_item.steps).to match_array(steps)
      end

      it 'calls analysis_modules_runner for each step' do
        steps.each do |step|
          expect_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
            .to receive(:analysis_modules_runner)
            .with(step.command_class, current_analysis, analysis_item)
        end

        described_class.call(analysis_item)
      end

      it 'breaks the loop if analysis item status is not wip' do
        allow(analysis_item).to receive(:status).and_return('done')

        described_class.call(analysis_item)

        expect(analysis_item.reload.status).to eq('done')
      end
    end
  end
end
