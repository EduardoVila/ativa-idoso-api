# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AnalysisReportRunnerCommand, type: :command do
  describe '#call' do
    context 'when status is done' do
      let(:analysis_report) do
        create :analysis_report, :done, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call analysis_item run_command' do
        expect_any_instance_of(Analysis::Item).not_to receive(:run_command) # rubocop:disable RSpec/AnyInstance

        described_class.new(analysis_report).call
      end
    end

    context 'when status is not_found' do
      let(:analysis_report) do
        create :analysis_report, :not_found, cpfs: [Faker::CPF.pretty]
      end

      it 'does not call analysis_item run' do
        expect_any_instance_of(Analysis::Item).not_to receive(:run_command) # rubocop:disable RSpec/AnyInstance

        described_class.new(analysis_report).call
      end
    end

    context 'when status is todo' do
      let(:analysis_report) { create :analysis_report, :todo }
      let(:analysis_item) { create :analysis_item, report: analysis_report }

      it 'calls service to create analysis items' do
        allow(Analysis::CreateAnalysisItemsService).to receive(:call)
          .with(analysis_report).and_return(analysis_item)

        expect_any_instance_of(Analysis::Item).to receive(:run_command).once # rubocop:disable RSpec/AnyInstance

        described_class.new(analysis_report).call
      end
    end
  end
end
