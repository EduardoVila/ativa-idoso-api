# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::StepByStepCommand, type: :command do
  let(:analysis_item) { create :analysis_item, :wip, error_status: :none }
  let(:command) { described_class.new(analysis_item) }

  describe '#call' do
    let(:current_item) { analysis_item }
    let(:steps) { create_list :analysis_step, 3 }

    before do
      allow(Analysis::Step).to receive_message_chain(:enabled, :order) # rubocop:disable RSpec/MessageChain
        .and_return(steps)
      allow(command).to receive(:run_step)
    end

    it 'adds steps to the analysis item' do
      command.call

      expect(analysis_item.steps).to match_array(steps)
    end

    it 'invokes steps for each step' do
      steps.each do |step|
        expect(command).to receive(:run_step) # rubocop:disable RSpec/MessageSpies
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
        expect(analysis_item.steps.first).to eq(steps.first)
      end
    end
  end

  describe '#run_step' do
    let(:analysis_step) do
      create :analysis_step
    end
    let(:analysis_item) do
      create :analysis_item, :clone, :wip, :with_steps, error_status: :none
    end
    let(:item_step) do
      create :analysis_item_step, item: analysis_item,
                                  step: analysis_step
    end
    let(:current_item) { analysis_item.clone_of }
    let(:command_class) { analysis_step.command_class }
    let(:result) do
      { status: 'failure', approved: false, disapproval_situation: 'foobar' }
    end

    before do
      allow(Invoker).to receive(:execute).and_return(result)
      allow(command).to receive(:update_item_status)
    end

    it 'executes the command' do
      command.send(:run_step, current_item, command_class, item_step)

      expect(Invoker).to have_received(:execute)
        .with(:a_step, current_item, command_class)
    end

    context 'when result is approved' do
      let(:result) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      it 'does not update the analysis item' do
        command.send(:run_step, current_item, command_class, item_step)

        expect(command).not_to have_received(:update_item_status)
      end
    end

    context 'when command class is Analysis::PredictionCommand' do
      let(:command_class) { 'Analysis::PredictionCommand' }

      it 'updates the analysis item with the result' do
        allow(command).to receive(:update_item_status)

        command.send(:run_step, current_item, command_class, item_step)

        expect(command).to have_received(:update_item_status)
          .with(result)
      end
    end

    context 'when command class is PrePredictionCommand' do
      let(:command_class) { 'PrePredictionCommand' }

      it 'creates an analysis prediction' do
        allow(command).to receive(:create_analysis_prediction)

        command.send(:run_step, current_item, command_class, item_step)

        expect(command).to have_received(:create_analysis_prediction)
      end
    end

    it 'updates the analysis item with the result' do
      command.send(:run_step, current_item, command_class, item_step)

      expect(command).to have_received(:update_item_status)
        .with(result)
    end
  end

  describe '#update_item_status' do
    before { allow(analysis_item).to receive(:update) }

    context 'when result status is failure' do
      let(:result) { { status: 'failure', disapproval_situation: 'foobar' } }

      it 'updates the analysis item status to error' do
        command.send(:update_item_status, result)
        expect(analysis_item).to have_received(:update).with(
          status: :error
        )
      end
    end

    context 'when result status is not_found' do
      let(:result) { { status: 'not_found' } }

      it 'updates the analysis item status to not_found' do
        command.send(:update_item_status, result)
        expect(analysis_item).to have_received(:update).with(
          status: :not_found
        )
      end
    end

    context 'when result status is success but not approved' do
      let(:features) { analysis_item.featurable }
      let(:result) do
        { status: 'success', approved: false, disapproval_situation: 'foobar' }
      end

      it 'updates the item status to done and sets disapproval_situation' do
        command.send(:update_item_status, result)
        expect(analysis_item).to have_received(:update).with(
          status: :done,
          disapproval_situation: result[:disapproval_situation]
        )
      end
    end

    context 'when result status is success and approved' do
      let(:features) { analysis_item.featurable }
      let(:result) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      it 'updates item status to done and sets features and step exec data' do
        command.send(:update_item_status, result)
        expect(analysis_item).to have_received(:update).with(
          status: :done
        )
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
