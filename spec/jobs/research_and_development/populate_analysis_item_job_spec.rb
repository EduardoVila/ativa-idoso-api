# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe ResearchAndDevelopment::PopulateAnalysisItemJob, type: :job do
  subject { described_class.new }

  describe '#perform' do
    let(:analysis_item_service) do
      instance_double(ResearchAndDevelopment::PopulateAnalysisItemService)
    end
    let!(:analysis_item) { create :analysis_item }

    before do
      allow(ResearchAndDevelopment::PopulateAnalysisItemService).to(
        receive(:new)
      ).and_return(analysis_item_service)

      allow(analysis_item_service).to receive(:call)
    end

    it 'calls the call method on the analysis_item service' do
      subject.perform(analysis_item.id)

      expect(analysis_item_service).to have_received(:call)
    end
  end
end
