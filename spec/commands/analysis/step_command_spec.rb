# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::StepCommand, type: :command do
  let(:analysis_item) { create :analysis_item, :wip, error_status: :none }
  let(:command) { described_class.new(analysis_item) }

  describe '#call' do
    let(:current_analysis) { analysis_item }
    let(:steps) { create_list :analysis_step, 3 }

    before do
      allow(Analysis::Step).to receive_message_chain(:enabled, :order) # rubocop:disable RSpec/MessageChain
        .and_return(steps)
      allow(command).to receive(:invoke_steps)
    end

    it 'adds steps to the analysis item' do
      command.call

      expect(analysis_item.steps).to match_array(steps)
    end

    it 'invokes steps for each step' do
      steps.each do |step|
        expect(command).to receive(:invoke_steps) # rubocop:disable RSpec/MessageSpies
          .with(step.command_class, current_analysis)
      end

      command.call
    end

    context 'when analysis item status is wip' do
      before do
        allow(analysis_item).to receive(:status).and_return('wip')
      end

      it 'continues to the next step' do
        command.call
        expect(analysis_item.steps).to match_array(steps)
      end
    end

    context 'when analysis item status is not wip' do
      before do
        allow(analysis_item).to receive(:status).and_return('done')
      end

      it 'breaks the loop' do
        command.call
        expect(analysis_item.steps).to eq([steps.first])
      end
    end
  end

  describe '#invoke_steps' do
    let(:analysis_item) do
      create :analysis_item, :clone, :wip, error_status: :none
    end
    let(:current_analysis) { analysis_item }
    let(:command_class) { 'SomeCommandClass' }
    let(:result) do
      {
        approved: false,
        status: 'error',
        disapproval_situation: 'foobar'
      }
    end

    before do
      allow(Invoker).to receive(:execute).and_return(result)
      allow(command).to receive(:update_analysis_item)
    end

    it 'executes the command' do
      command.send(:invoke_steps, command_class, current_analysis)

      expect(Invoker).to have_received(:execute)
        .with(:a_step, current_analysis, command_class)
    end

    context 'when command class is Analysis::PredictionCommand' do
      let(:command_class) { 'Analysis::PredictionCommand' }

      it 'updates the analysis item status to done' do
        allow(analysis_item).to receive(:update)

        command.send(:invoke_steps, command_class, current_analysis)

        expect(analysis_item).to have_received(:update).with(
          status: :done, features: analysis_item.featurable
        )
      end
    end

    context 'when result is approved' do
      let(:result) { { approved: true } }

      it 'does not update the analysis item' do
        command.send(:invoke_steps, command_class, current_analysis)

        expect(command).not_to have_received(:update_analysis_item)
      end
    end

    context 'when command class is PrePredictionCommand' do
      let(:command_class) { 'PrePredictionCommand' }

      it 'creates an analysis prediction' do
        allow(command).to receive(:create_analysis_prediction)

        command.send(:invoke_steps, command_class, current_analysis)

        expect(command).to have_received(:create_analysis_prediction)
      end
    end

    it 'updates the analysis item with the result' do
      command.send(:invoke_steps, command_class, current_analysis)

      expect(command).to have_received(:update_analysis_item).with(result)
    end
  end

  describe '#update_analysis_item' do
    let(:result) { { status: 'error', disapproval_situation: 'foobar' } }

    it 'updates the analysis item status to error' do
      expect(analysis_item).to receive(:update).with(status: :error) # rubocop:disable RSpec/MessageSpies

      command.send(:update_analysis_item, result)
    end

    context 'when result status is not_found' do
      let(:result) { { status: 'not_found' } }

      it 'updates the analysis item status to not_found' do
        expect(analysis_item).to receive(:update).with(status: :not_found) # rubocop:disable RSpec/MessageSpies

        command.send(:update_analysis_item, result)
      end
    end

    context 'when result status is done' do
      let(:result) do
        {
          status: :done,
          disapproval_situation: 'foobar',
          features: analysis_item.featurable
        }
      end

      it 'updates the item status to done and sets disapproval_situation' do
        expect(analysis_item).to receive(:update) # rubocop:disable RSpec/MessageSpies
          .with(
            status: :done,
            disapproval_situation: 'foobar',
            features: analysis_item.featurable
          )

        command.send(:update_analysis_item, result)
      end
    end
  end

  describe '#create_analysis_prediction' do
    it 'creates an analysis prediction' do
      allow(Analysis::Prediction).to receive(:create)

      command.send(:create_analysis_prediction)

      expect(Analysis::Prediction).to have_received(:create)
        .with(label: 'pre_prediction', item: analysis_item, approved: false)
    end
  end
end
