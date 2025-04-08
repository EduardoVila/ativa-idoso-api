# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe AnalysisReportJob, type: :job do
  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let(:webhook_event) do
      create :api_webhook_event,
             event_id: analysis_report.id,
             client: analysis_report.api_client
    end

    before do
      allow(Analysis::Report).to receive(:find).with(analysis_report.id)
        .and_return(analysis_report)
      allow(Api::WebhookEvent).to receive(:find_by)
        .with(event_id: analysis_report.id)
        .and_return(webhook_event)
      allow(Invoker).to receive(:execute)
    end

    context 'when webhook_event is not found' do
      before do
        allow(Api::WebhookEvent).to receive(:find_by)
          .with(event_id: analysis_report.id)
          .and_return(nil)
      end

      it 'does not process the job' do
        described_class.new.perform(analysis_report.id)
        expect(Invoker).not_to have_received(:execute)
      end
    end

    context 'when webhook_event is found' do
      it 'processes the webhook event' do
        described_class.new.perform(analysis_report.id)
        expect(webhook_event.reload.status).to eq('processing')
        expect(webhook_event.reload.job_id).not_to be_nil
      end

      it 'runs the analysis report' do
        described_class.new.perform(analysis_report.id)
        expect(Invoker).to have_received(:execute)
          .with(:analysis_report_runner_command, analysis_report)
      end

      context 'when analysis report is done or not found' do
        before do
          allow(analysis_report).to receive(:status).and_return('done')
        end

        it 'does not process analysis items' do
          described_class.new.perform(analysis_report.id)
          expect(Invoker).not_to have_received(:execute)
            .with(:analysis_item_runner_command, anything)
        end
      end

      context 'when analysis report is not done or not found' do
        let!(:analysis_items) do
          create_list :analysis_item, 2, report: analysis_report
        end

        before do
          allow(analysis_report).to receive_messages(
            status: 'todo', reload: analysis_report, items: analysis_items
          )
        end

        it 'processes analysis items' do
          described_class.new.perform(analysis_report.id)
          analysis_items.each do |item|
            expect(Invoker).to have_received(:execute)
              .with(:analysis_item_runner_command, item)
          end
        end

        it 'updates the webhook event payload' do
          described_class.new.perform(analysis_report.id)
          expect(webhook_event.reload.payload)
            .to eq(analysis_report.serialize_record.as_json)
        end

        it 'triggers the webhook event' do
          described_class.new.perform(analysis_report.id)
          expect(Invoker).to have_received(:execute)
            .with(:api_webhook_trigger_command, webhook_event)
        end
      end
    end
  end
end
