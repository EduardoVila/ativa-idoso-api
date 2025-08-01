# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

RSpec.describe AnalysisReportJob do
  subject { described_class }

  describe '#perform' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let!(:webhook_event) do
      create :api_webhook_event,
             analysis_report_id: analysis_report.id
    end
    let(:delivery_spy) { instance_spy(Api::WebhookDeliveryService) }
    let(:invoker_spy) { class_spy(Invoker) }

    before do
      allow(Analysis::Report).to receive(:find).with(analysis_report.id)
        .and_return(analysis_report)

      stub_const('Invoker', invoker_spy)
      allow(Invoker).to receive(:execute)

      allow(Api::WebhookDeliveryService).to receive(:new)
        .and_return(delivery_spy)
      allow(delivery_spy).to receive(:call)

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

    context 'when webhook_event is not found' do
      before do
        analysis_report.api_webhook_events.destroy_all
      end

      it 'does not process the job' do
        Sidekiq::Testing.fake! do
          described_class.new.perform(analysis_report.id)

          expect(invoker_spy).not_to have_received(:execute)
        end
      end
    end

    context 'when webhook_event is found' do
      context 'when analysis report is done or not found' do
        before do
          allow(analysis_report).to receive(:status).and_return('done')
        end

        it 'does not process analysis items' do
          Sidekiq::Testing.fake! do
            described_class.new.perform(analysis_report.id)

            expect(invoker_spy).not_to have_received(:execute)
              .with(:analysis_item_runner_command, anything)
          end
        end
      end

      context 'when analysis report is not done' do
        let!(:analysis_items) do
          create_list :analysis_item, 2, report: analysis_report
        end

        before do
          allow(analysis_report).to receive_messages(
            status: 'todo', reload: analysis_report, items: analysis_items
          )
        end

        it 'processes analysis items' do
          Sidekiq::Testing.fake! do
            described_class.new.perform(analysis_report.id)

            analysis_items.each do |item|
              expect(invoker_spy).to have_received(:execute)
                .with(:analysis_item_runner_command, item)
            end
          end
        end

        it 'delivers the webhook' do
          Sidekiq::Testing.fake! do
            described_class.new.perform(analysis_report.id)

            expect(delivery_spy).to have_received(:call)
              .with([webhook_event], analysis_report.reload)
          end
        end
      end
    end
  end
end
