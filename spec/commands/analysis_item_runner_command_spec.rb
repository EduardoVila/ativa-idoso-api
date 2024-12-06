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
  end
end
