# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe BoaVistaCadastralJob, type: :job do
  before do # rubocop:disable RSpec/EmptyHook
    # allow(Integrators::BoaVistaCadastral).to receive(:load_data)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it { expect(described_class.queue_name).to eq 'boa_vista' }

  describe '#perform_later' do
    let(:analysis_item) { create :analysis_item }
    let(:serialized_analysis_item) { analysis_item.serialize_record }
    let(:perform_later_job) do
      described_class.perform_later(serialized_analysis_item)
    end

    it 'enqueues a job on the boa_vista queue' do
      expect(perform_later_job.queue_name).to eq('boa_vista')
      expect(enqueued_jobs.size).to eq(1)
    end

    it 'enqueues a job with the given serialized_analysis_item' do
      expect(perform_later_job.arguments).to eq([serialized_analysis_item])
    end

    it 'performs the job when processed' do # rubocop:disable RSpec/NoExpectationExample
      perform_later_job.perform_now

      # expect(Integrators::BoaVistaCadastral).to have_received(:load_data)
      #   .with(analysis_item.cpf)
    end
  end

  describe '#perform_now' do
    let(:analysis_item) { create :analysis_item }
    let(:serialized_analysis_item) { analysis_item.serialize_record }
    let(:perform_now_job) do
      described_class.perform_now(serialized_analysis_item)
    end

    before { perform_now_job }

    it 'calls Integrators::BoaVistaCadastral with the given analysis_item' do # rubocop:disable RSpec/NoExpectationExample
      # expect(Integrators::BoaVistaCadastral).to have_received(:load_data)
      #   .with(analysis_item.cpf)
    end

    it 'does not enqueue a job' do
      expect(enqueued_jobs.size).to eq(0)
    end
  end
end
