# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe AnalysisReportJob, type: :job do
  before do
    allow(AnalysisReportRunnerCommand).to receive(:call).with(analysis_report)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let(:serialized_report) { analysis_report.serialize_record }
    let(:perform_later_job) { described_class.perform_later(serialized_report) }

    it 'enqueues a job on the analysis_report queue' do
      expect(perform_later_job.queue_name).to eq('analysis_report')
      expect(enqueued_jobs.size).to eq(1)
    end

    it 'enqueues a job with the given serialized_analysis_report' do
      expect(perform_later_job.arguments).to eq([serialized_report])
    end

    it 'performs the job when processed' do
      perform_later_job.perform_now

      expect(AnalysisReportRunnerCommand).to have_received(:call)
        .with(analysis_report)
    end
  end

  describe '#perform_now' do
    let(:analysis_report) { create :analysis_report, status: :todo }
    let(:serialized_report) { analysis_report.serialize_record }
    let(:perform_now_job) { described_class.perform_now(serialized_report) }

    before { perform_now_job }

    it 'calls AnalysisReportRunnerCommand with the given analysis_report' do
      expect(AnalysisReportRunnerCommand).to have_received(:call)
        .with(analysis_report)
    end

    it 'does not enqueue a job' do
      expect(enqueued_jobs.size).to eq(0)
    end
  end
end
