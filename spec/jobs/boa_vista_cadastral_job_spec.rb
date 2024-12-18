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
    let(:perform_later_job) { described_class.perform_later(analysis_item.id) }

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
    let(:perform_now_job) { described_class.perform_now(analysis_item.id) }

    it 'calls Integrators::BoaVistaCadastral with the given analysis_item' do
      perform_now_job

      expect(integrator).to have_received(:create_resource).with(analysis_item)
      expect(enqueued_jobs.size).to eq(0)
    end
  end
end
