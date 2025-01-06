# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::ReportRunnerCommand, type: :command do
  subject(:command) { described_class.new(analysis_report) }

  describe '#call' do
    before do
      allow(Analysis::CreateAnalysisItemsService).to receive(:call)
    end

    context 'when status is :done' do
      let(:analysis_report) do
        create :analysis_report, :done, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call Analysis::CreateAnalysisItemsService' do
        command.call

        expect(Analysis::CreateAnalysisItemsService).not_to have_received(:call)
      end
    end

    context 'when status is :not_found' do
      let(:analysis_report) do
        create :analysis_report, :not_found, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call Analysis::CreateAnalysisItemsService' do
        command.call

        expect(Analysis::CreateAnalysisItemsService).not_to have_received(:call)
      end
    end

    context 'when status is :todo' do
      let(:analysis_report) { create :analysis_report, :todo }
      let(:analysis_item) { create :analysis_item, report: analysis_report }

      it 'calls service to create analysis items' do
        allow(Analysis::CreateAnalysisItemsService).to receive(:call)
          .with(analysis_report).and_return(analysis_item)

        command.call

        expect(Analysis::CreateAnalysisItemsService).to have_received(:call)
          .with(analysis_report)
      end

      it 'updates the status to :wip' do
        command.call

        expect(analysis_report.reload.status).to eq('wip')
      end
    end
  end
end
