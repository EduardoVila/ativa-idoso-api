# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResearchAndDevelopment::PopulateAnalysisItemService,
               type: :service do
  describe '#call' do
    let(:analysis_item) { create :analysis_item, :done }
    let(:created) { ResearchAndDevelopment::AnalysisItem.last }

    before do
      allow(ResearchAndDevelopment::AnalysisItem).to receive(:create)
        .and_call_original
    end

    it 'creates ResearchAndDevelopment::AnalysisItem with analysis_item data' do
      expect do
        described_class.call(analysis_item)
      end.to change(ResearchAndDevelopment::AnalysisItem, :count).by(1)

      expect(created.analysis_items_cpf).to eq(analysis_item.cpf)
    end
  end
end
