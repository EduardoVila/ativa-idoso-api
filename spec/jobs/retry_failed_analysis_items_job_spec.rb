# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe RetryFailedAnalysisItemsJob do
  subject { described_class.new }

  describe '#call' do
    # Set up spies for delivery service and invoker
    let(:delivery_spy) { instance_spy(Api::WebhookDeliveryService) }
    let(:invoker_spy) { class_spy(Invoker) }

    before do
      # Set up delivery service spy to track calls
      allow(Api::WebhookDeliveryService).to receive(:new)
        .and_return(delivery_spy)
      allow(delivery_spy).to receive(:call)

      # Set up Invoker spy to track calls
      stub_const('Invoker', invoker_spy)
      allow(invoker_spy).to receive(:execute)

      # Clear Sidekiq jobs before each test
      Sidekiq::Testing.fake! do
        Sidekiq::Job.clear_all
      end
    end

    # Clear Sidekiq jobs after each test
    after do
      Sidekiq::Testing.fake! do
        Sidekiq::Job.clear_all
      end
    end

    context 'when it performs correctly' do
      let(:retry_record) { create :analysis_report, :error }
      let!(:error_item) { create :analysis_item, :error, report: retry_record }
      let!(:webhook_event) do
        create :api_webhook_event,
               analysis_report_id: retry_record.id
      end

      it 'executes the :retry_command on the Invoker' do
        Sidekiq::Testing.fake! do
          subject.perform(retry_record&.id)

          expect(invoker_spy).to have_received(:execute).once
            .with(:analysis_item_runner_command, error_item)
        end
      end

      it 'updates the retry_record status in the process' do
        Sidekiq::Testing.fake! do
          allow(retry_record).to receive(:update).and_call_original

          expect { subject.perform(retry_record&.id) }
            .to change { retry_record.reload.status }
            .from('error').to('wip')
        end
      end

      it 'calls the delivery service' do
        Sidekiq::Testing.fake! do
          subject.perform(retry_record&.id)

          expect(delivery_spy).to have_received(:call)
            .with(retry_record.api_webhook_events, retry_record.reload)
        end
      end
    end

    context 'when there is no item with error' do
      let(:retry_record) { create :analysis_report, :error }
      let!(:done_item) { create :analysis_item, :done, report: retry_record }
      let!(:webhook_event) do
        create :api_webhook_event, analysis_report_id: retry_record.id
      end

      it 'does nothing' do
        Sidekiq::Testing.fake! do
          allow(retry_record).to receive(:update).and_call_original

          subject.perform(retry_record&.id)

          expect(invoker_spy).not_to have_received(:execute)
          expect(retry_record).not_to have_received(:update)
        end
      end
    end
  end
end
