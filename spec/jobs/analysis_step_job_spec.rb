# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'does nothing' do
  it 'does nothing' do
    allow(analysis_item).to receive(:update).and_call_original

    subject

    expect(Invoker).not_to have_received(:execute)
    expect(analysis_item).not_to have_received(:update)
  end
end

RSpec.describe AnalysisStepJob, type: :job do
  subject { job_instance.perform(analysis_item&.id, analysis_step&.id) }

  let(:job_instance) { described_class.new }

  describe '#call' do
    before { allow(Invoker).to receive(:execute) }

    context 'when it performs correctly' do
      let(:analysis_item) { create :analysis_item }
      let(:analysis_step) { create :analysis_step }
      let!(:webhook_event) do
        create :api_webhook_event, event_id: analysis_item.analysis_report_id
      end

      it 'calls analysis_step command' do
        subject

        expect(Invoker).to have_received(:execute).once
          .with(:a_step, analysis_item, analysis_step.command_class)
      end

      it 'changes status of analysis_item to wip and after to done' do
        allow(analysis_item).to receive(:update).and_call_original.twice

        expect { subject }.to change { analysis_item.steps.count }.by(1)
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
