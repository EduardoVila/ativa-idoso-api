# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RetryFailedAnalysisItemsJob, type: :job do
  subject { job_instance.perform(retry_record&.id) }

  let(:job_instance) { described_class.new }

  describe '#call' do
    before { allow(Invoker).to receive(:execute) }

    context 'when it performs correctly' do
      let(:retry_record) { create :analysis_report, :error }
      let!(:error_item) { create :analysis_item, :error, report: retry_record }
      let!(:webhook_event) do
        create :api_webhook_event, event_id: retry_record.id
      end

      it 'executes the :retry_command on the Invoker' do
        subject

        expect(Invoker).to have_received(:execute).once
          .with(:analysis_item_runner_command, error_item)
      end

      it 'updates the retry_record status in the process' do
        allow(retry_record).to receive(:update).and_call_original

        expect { subject }.to change { retry_record.reload.status }
          .from('error').to('wip')
      end
    end

    context 'when there is no item with error' do
      let(:retry_record) { create :analysis_report, :error }
      let!(:done_item) { create :analysis_item, :done, report: retry_record }
      let!(:webhook_event) do
        create :api_webhook_event, event_id: retry_record.id
      end

      it 'does nothing' do
        allow(retry_record).to receive(:update).and_call_original

        subject

        expect(Invoker).not_to have_received(:execute)
        expect(retry_record).not_to have_received(:update)
      end
    end
  end
end
