# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.shared_examples 'does nothing' do
  it 'does nothing' do
    allow(analysis_item).to receive(:update).and_call_original

    subject

    expect(Invoker).not_to have_received(:execute)
    expect(analysis_item).not_to have_received(:update)
  end
end

RSpec.describe NextAnalysisStepJob do
  subject { job_instance.perform(analysis_item&.id, analysis_step&.id) }

  let(:job_instance) { described_class.new }

  describe '#call' do
    before { allow(Invoker).to receive(:execute) }

    context 'when it performs correctly' do
      let(:analysis_item) { create :analysis_item }
      let(:analysis_step) { create :analysis_step }
      let!(:webhook_event) do
        create :api_webhook_event,
               analysis_report_id: analysis_item.analysis_report_id
      end

      it 'invokes the next step of the analysis process' do
        Sidekiq::Testing.fake! do
          subject

          expect(Invoker).to have_received(:execute).once
            .with(
              :analysis_next_step_command,
              analysis_item,
              analysis_step.command_class
            )
        end
      end

      it 'invokes the api webhook trigger command to callback the requester' do
        Sidekiq::Testing.fake! do
          subject

          expect(Invoker).to have_received(:execute).once
            .with(
              :api_webhook_trigger_command,
              webhook_event
            )
        end
      end
    end

    context 'when analysis_item has already analysis_step runned' do
      let(:analysis_item) { create :analysis_item }
      let(:analysis_step) { create :analysis_step }

      before do
        analysis_item.steps << analysis_step
      end

      it_behaves_like 'does nothing'
    end

    context 'when missing analysis_item' do
      let(:analysis_step) { create :analysis_step }
      let(:analysis_item) { nil }

      it_behaves_like 'does nothing'
    end

    context 'when missing analysis_step' do
      let(:analysis_item) { create :analysis_item }
      let(:analysis_step) { nil }

      it_behaves_like 'does nothing'
    end
  end
end
