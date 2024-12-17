# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe AnalysisReportJob, type: :job do
  before do
    allow(Analysis::ReportRunnerCommand).to receive(:call).with(analysis_report)
      .and_return(analysis_report)
    allow(API::WebhookTriggerCommand).to receive(:call).with(webhook_event)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let(:perform_later_job) do
      described_class.perform_later(analysis_report.id)
    end
    let(:webhook_event) do
      create :api_webhook_event, event_id: analysis_report.id,
                                 client: analysis_report.api_client
    end

    it 'enqueues a job on the analysis_report queue' do
      expect(perform_later_job.queue_name).to eq('analysis_report')
      expect(enqueued_jobs.size).to eq(1)
    end

    it 'enqueues a job with the given serialized_analysis_report' do
      expect(perform_later_job.arguments).to eq(
        [analysis_report.id]
      )
    end

    it 'performs the job when processed' do
      perform_later_job.perform_now

      expect(Analysis::ReportRunnerCommand).to have_received(:call)
        .with(analysis_report)
      expect(API::WebhookTriggerCommand).to have_received(:call)
        .with(webhook_event)
    end
  end

  describe '#perform_now' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let(:perform_now_job) { described_class.perform_now(analysis_report.id) }
    let(:webhook_event) do
      create :api_webhook_event, event_id: analysis_report.id,
                                 client: analysis_report.api_client
    end

    before { perform_now_job }

    it 'calls Analysis::ReportRunnerCommand with the given analysis_report' do
      expect(Analysis::ReportRunnerCommand).to have_received(:call)
        .with(analysis_report)
    end

    it 'calls API::WebhookTriggerCommand with the given webhook_event' do
      expect(API::WebhookTriggerCommand).to have_received(:call)
        .with(webhook_event)
    end

    it 'does not enqueue a job' do
      expect(enqueued_jobs.size).to eq(0)
    end
  end
end
