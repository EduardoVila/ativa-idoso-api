# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AnalysisItemRunnerCommand, type: :command do
  describe '#call' do
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
  end
end
