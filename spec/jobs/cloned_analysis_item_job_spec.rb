# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClonedAnalysisItemJob, type: :job do
  subject { described_class }

  let(:analysis_item) { create :analysis_item, :clone }
  let(:webhook_event) do
    create :api_webhook_event, event_id: analysis_item.analysis_report_id
  end
  let(:job_instance) { subject.new }

  before do
    allow(job_instance).to receive_messages(
      find_analysis_item: analysis_item, find_webhook_event: webhook_event
    )
    allow(job_instance).to receive(:process_analysis_item)
    allow(job_instance).to receive(:update_webhook_event_payload)
    allow(job_instance).to receive(:trigger_webhook_event)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it { expect(subject.queue_name).to eq 'cloned_analysis_item' }

  describe '#perform' do
    context 'when clone_of_id is present' do
      it 'updates the webhook event' do
        job_instance.perform(analysis_item.id)

        expect(webhook_event.reload.status).to eq 'processing'
      end

      it 'updates the analysis item' do
        job_instance.perform(analysis_item.id)

        expect(analysis_item.reload.clone_of_id).to be_nil
        expect(analysis_item.reload.status).to eq 'todo'
        expect(analysis_item.reload.name).to be_nil
      end

      it 'updates the analysis report status to wip' do
        job_instance.perform(analysis_item.id)

        expect(analysis_item.report.reload.status).to eq 'wip'
      end

      it 'destroys all predictions of the analysis item' do
        create :analysis_prediction, item: analysis_item

        expect { job_instance.perform(analysis_item.id) }.to change {
          analysis_item.predictions.count
        }.to(0)
      end

      it 'processes the analysis item' do
        allow(job_instance).to receive(:process_analysis_item)

        job_instance.perform(analysis_item.id)

        expect(job_instance).to have_received(:process_analysis_item)
          .with(analysis_item)
      end

      it 'updates the webhook event payload' do
        allow(job_instance).to receive(:update_webhook_event_payload)

        job_instance.perform(analysis_item.id)

        expect(job_instance).to have_received(:update_webhook_event_payload)
          .with(webhook_event, analysis_item.report)
      end

      it 'triggers the webhook event' do
        job_instance.perform(analysis_item.id)

        expect(job_instance).to have_received(:trigger_webhook_event)
          .with(webhook_event)
      end
    end

    context 'when clone_of_id is blank' do
      before { analysis_item.update(clone_of_id: nil) }

      it 'does not process the webhook event' do
        job_instance.perform(analysis_item.id)

        expect(webhook_event.reload.status).not_to eq 'processing'
      end
    end
  end
end
