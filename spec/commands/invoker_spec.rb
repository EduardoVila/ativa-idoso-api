# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Invoker, type: :model do
  describe '.execute' do
    let(:command) { :analysis_report_runner_command }
    let(:object) { instance_double(Object) }

    before do
      allow(Analysis::ReportRunnerCommand).to receive(:call)
    end

    it 'calls the correct command with the given argument' do
      described_class.execute(command, object)
      expect(Analysis::ReportRunnerCommand).to have_received(:call).with(object)
    end

    context 'when command is :a_step' do
      let(:command) { :a_step }
      let(:klass_name) { 'Analysis::PredictionCommand' }

      before do
        allow(Analysis::PredictionCommand).to receive(:call)
      end

      it 'calls the specified class with the given argument' do
        described_class.execute(command, object, klass_name)
        expect(Analysis::PredictionCommand).to have_received(:call).with(object)
      end
    end

    context 'when command is unknown' do
      let(:command) { :unknown_command }

      it 'raises an ArgumentError' do
        expect { described_class.execute(command, object) }
          .to raise_error(ArgumentError, "Unknown command: #{command}")
      end
    end
  end
end
