# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe BoaVistaCadastralJob, type: :job do
  let(:integrator) { instance_double(BoaVista::CadastralIntegrator) }

  before do
    allow(BoaVista::CadastralIntegrator).to receive(:new)
      .and_return(integrator)

    allow(integrator).to receive(:create_resource)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it { expect(described_class.queue_name).to eq 'boa_vista' }

  describe '#perform_later' do
    let(:analysis_item) { create :analysis_item }
    let(:perform_later_job) do
      described_class.perform_later(analysis_item.id)
    end

    it 'enqueues a job on the boa_vista queue' do
      expect(perform_later_job.queue_name).to eq('boa_vista')
      expect(enqueued_jobs.size).to eq(1)
    end

    it 'enqueues a job with the given analysis_item id' do
      expect(perform_later_job.arguments).to eq([analysis_item.id])
    end

    it 'performs the job when processed' do
      perform_later_job.perform_now

      expect(integrator).to have_received(:create_resource).with(analysis_item)
    end
  end

  describe '#perform_now' do
    let(:analysis_item) { create :analysis_item }
    let(:perform_now_job) do
      described_class.perform_now(analysis_item.id)
    end

    it 'calls Integrators::BoaVistaCadastral with the given analysis_item id' do
      perform_now_job

      expect(integrator).to have_received(:create_resource).with(analysis_item)
      expect(enqueued_jobs.size).to eq(0)
    end
  end

  describe '#perform' do
    let(:analysis_item) { create :analysis_item }

    before do
      allow(Analysis::Item).to receive(:find).and_return(analysis_item)
      allow(Analysis::ReportSyncCommand).to receive(:call)
    end

    context 'when boa_vista_cadastral is present' do
      before do
        allow(analysis_item).to receive(:boa_vista_cadastral).and_return(double)
      end

      it 'does not call create_resource' do
        described_class.new.perform(analysis_item.id)
        expect(integrator).not_to have_received(:create_resource)
      end
    end

    context 'when error_status is boa_vista' do
      before { analysis_item.update(error_status: 'boa_vista') }

      it 'resets error_status to none' do
        described_class.new.perform(analysis_item.id)
        expect(analysis_item.error_status).to eq('none')
      end
    end

    context 'when create_resource raises BoaVistaResponseError' do
      before do
        allow(integrator).to receive(:create_resource)
          .and_raise(BoaVistaResponseError)
      end

      it 'updates status to error and calls ReportSyncCommand' do
        described_class.new.perform(analysis_item.id)
        expect(analysis_item.status).to eq('error')
        expect(analysis_item.error_status).to eq('boa_vista')
        expect(Analysis::ReportSyncCommand).to have_received(:call)
          .with(analysis_item.report)
      end
    end

    context 'when create_resource raises StandardError' do
      before do
        allow(integrator).to receive(:create_resource).and_raise(StandardError)
      end

      it 'updates status to not_found and calls ReportSyncCommand' do
        described_class.new.perform(analysis_item.id)
        expect(analysis_item.status).to eq('not_found')
        expect(analysis_item.error_status).to eq('boa_vista')
        expect(Analysis::ReportSyncCommand).to have_received(:call)
          .with(analysis_item.report)
      end
    end
  end
end
