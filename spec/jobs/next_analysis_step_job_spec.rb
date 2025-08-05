# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.shared_examples 'does nothing' do
  it 'does nothing' do
    allow(analysis_item).to receive(:update).and_call_original

    subject.perform(analysis_item&.id, analysis_step&.id)

    expect(invoker_spy).not_to have_received(:execute)
    expect(analysis_item).not_to have_received(:update)
  end
end

RSpec.describe NextAnalysisStepJob do
  subject { described_class.new }

  describe '#perform' do
    let(:delivery_spy) { instance_spy(Api::WebhookDeliveryService) }
    let(:invoker_spy) { class_spy(Invoker) }

    before do
      allow(Api::WebhookDeliveryService).to receive(:new)
        .and_return(delivery_spy)
      allow(delivery_spy).to receive(:call)

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
      let(:analysis_item) { create :analysis_item }
      let(:analysis_step) { create :analysis_step }
      let!(:webhook_event) do
        create :api_webhook_event,
               analysis_report_id: analysis_item.analysis_report_id
      end

      it 'invokes the next step of the analysis process' do
        Sidekiq::Testing.fake! do
          subject.perform(analysis_item&.id, analysis_step&.id)

          expect(invoker_spy).to have_received(:execute).once
            .with(
              :analysis_next_step_command,
              analysis_item,
              analysis_step.command_class
            )
        end
      end

      it 'calls the delivery service' do
        Sidekiq::Testing.fake! do
          subject.perform(analysis_item&.id, analysis_step&.id)

          expect(delivery_spy).to have_received(:call)
            .with([webhook_event], analysis_item.report.reload)
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
