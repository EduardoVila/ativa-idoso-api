# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AnalysisReportRunnerCommand, type: :command do
  describe '#call' do
    context 'when status is :done' do
      let(:analysis_report) do
        create :analysis_report, :done, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call Analysis Item Runner Command' do
        allow(AnalysisItemRunnerCommand).to receive(:call)

        described_class.call(analysis_report)

        expect(AnalysisItemRunnerCommand).not_to have_received(:call)
      end
    end

    context 'when status is :not_found' do
      let(:analysis_report) do
        create :analysis_report, :not_found, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call Analysis Item Runner Command' do
        allow(AnalysisItemRunnerCommand).to receive(:call)

        described_class.call(analysis_report)

        expect(AnalysisItemRunnerCommand).not_to have_received(:call)
      end
    end

    context 'when status is :todo' do
      let(:analysis_report) { create :analysis_report, :todo }
      let(:analysis_item) { create :analysis_item, report: analysis_report }

      it 'calls service to create analysis items' do
        allow(Analysis::CreateAnalysisItemsService).to receive(:call)
          .with(analysis_report).and_return(analysis_item)

        allow(AnalysisItemRunnerCommand).to receive(:call).with(analysis_item)
          .and_return(analysis_item)

        described_class.call(analysis_report)

        expect(Analysis::CreateAnalysisItemsService).to have_received(:call)
          .with(analysis_report)

        expect(AnalysisItemRunnerCommand).to have_received(:call)
          .with(analysis_item)
      end
    end
  end
end
