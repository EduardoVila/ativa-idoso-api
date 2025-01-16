# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClonedAnalysisItemJob, type: :job do
  subject do
    described_class
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it { expect(subject.queue_name).to eq 'cloned_analysis_item' }

  describe 'perform' do

  end
end
