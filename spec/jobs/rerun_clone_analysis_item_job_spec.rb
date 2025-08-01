# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.shared_examples 'does nothing' do
  it 'invoker and delivery service does not receive messages' do
    subject.perform(analysis_item.id)

    expect(invoker_spy).not_to have_received(:execute)
    expect(delivery_spy).not_to have_received(:call)
  end
end

RSpec.describe RerunCloneAnalysisItemJob do
  subject { described_class.new }

  describe '#perform' do
    let(:analysis_report) { create :analysis_report, status: :wip }
    let(:analysis_item) do
      create :analysis_item, :clone, report: analysis_report
    end
    let!(:webhook_event) do
      create :api_webhook_event, analysis_report_id: analysis_report.id
    end
    # Set up spies for delivery service and invoker
    let(:delivery_spy) { instance_spy(Api::WebhookDeliveryService) }
    let(:invoker_spy) { class_spy(Invoker) }

    before do
      allow(Analysis::Item).to receive(:find).with(analysis_item.id)
        .and_return(analysis_item)

      # Set up delivery service spy to track calls
      allow(Api::WebhookDeliveryService).to receive(:new)
        .and_return(delivery_spy)
      allow(delivery_spy).to receive(:call)

      # Set up Invoker spy to track calls
      stub_const('Invoker', invoker_spy)
      allow(invoker_spy).to receive(:execute)

      allow(analysis_item).to receive_messages(
        predictions: instance_double(
          ActiveRecord::Associations::CollectionProxy, destroy_all: true
        ),
        steps: instance_double(
          ActiveRecord::Associations::CollectionProxy, destroy_all: true
        ),
        report: analysis_report
      )
      allow(analysis_report).to receive_messages(
        api_webhook_events: [webhook_event], reload: analysis_report
      )

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

    context 'when analysis_item is a clone and webhook_event exists' do
      it 'resets clone status, processes item, and delivers webhooks' do
        expect(analysis_item).to receive(:update!)
          .with(clone_of_id: nil, status: :todo, name: nil)
        expect(analysis_report).to receive(:update!).with(status: :wip)

        subject.perform(analysis_item.id)

        expect(delivery_spy).to have_received(:call)
          .with([webhook_event], analysis_report)
        expect(invoker_spy).to have_received(:execute)
          .with(:analysis_item_runner_command, analysis_item)
      end

      it 'updates webhook_event status to processing and sets job_id' do
        expect(webhook_event).to receive(:update!)
          .with(hash_including(status: :processing, job_id: anything))

        subject.perform(analysis_item.id)
      end
    end

    context 'when analysis_item is not a clone' do
      before { allow(analysis_item).to receive(:clone_of_id).and_return(nil) }

      it_behaves_like 'does nothing'
    end

    context 'when no unprocessed webhook_events exist' do
      before do
        allow(analysis_report).to receive(:api_webhook_events).and_return([])
      end

      it_behaves_like 'does nothing'
    end
  end
end
