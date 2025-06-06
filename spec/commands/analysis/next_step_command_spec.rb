# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::NextStepCommand, type: :command do
  subject(:command) { described_class.new(analysis_item, command_class) }

  let(:analysis_item) { create :analysis_item, :wip }
  let(:analysis_report) { analysis_item.report }
  let(:command_class) { 'PrePredictionCommand' }
  let(:analysis_step) { create :analysis_step, command_class: command_class }

  before do
    allow(Invoker).to receive(:execute)
    allow(Time).to receive(:current)
      .and_return(Time.zone.parse('2023-01-01 10:00:00'))
  end

  describe '#initialize' do
    context 'when analysis_item is present' do
      it 'sets the analysis_item, command_class, and analysis_report' do
        expect(command.analysis_item).to eq(analysis_item)
        expect(command.command_class).to eq(command_class)
        expect(command.analysis_report).to eq(analysis_report)
      end
    end

    context 'when analysis_item is nil' do
      let(:analysis_item) { nil }

      it 'raises an error' do
        expect { command }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#call' do
    context 'when analysis_item is nil' do
      subject(:command) { described_class.allocate }

      before do
        command.instance_variable_set(:@analysis_item, nil)
        command.instance_variable_set(:@command_class, command_class)
        command.instance_variable_set(:@analysis_report, nil)
      end

      it 'returns early without processing' do
        expect(command.call).to be_nil
        expect(Invoker).not_to have_received(:execute)
      end
    end

    context 'when command_class is nil' do
      subject(:command) { described_class.allocate }

      let(:command_class) { nil }

      before do
        command.instance_variable_set(:@analysis_item, analysis_item)
        command.instance_variable_set(:@command_class, nil)
        command.instance_variable_set(:@analysis_report, analysis_report)
      end

      it 'returns early without processing' do
        expect(command.call).to be_nil
        expect(Invoker).not_to have_received(:execute)
      end
    end

    context 'when enabled_step is not found' do
      before do
        allow(Analysis::Step).to receive(:find_by)
          .with(command_class: command_class).and_return(nil)
      end

      it 'returns early without processing' do
        expect(command.call).to be_nil
        expect(Invoker).not_to have_received(:execute)
      end
    end

    context 'when current_item already includes the enabled_step' do
      let(:current_item) { analysis_item }

      before do
        current_item.steps << analysis_step
        allow(Analysis::Step).to receive(:find_by)
          .with(command_class: command_class).and_return(analysis_step)
        allow(current_item).to receive(:steps_summary)
          .and_return({ step_data: 'summary' })
      end

      it 'returns early without processing the step' do
        command.call
        expect(Invoker).not_to have_received(:execute)
          .with(:a_step, anything, anything)
      end

      it 'still updates analysis_item status to wip' do
        command.call
        expect(analysis_item.reload.status).to eq('wip')
      end
    end

    context 'when processing a new step' do
      let(:current_item) { analysis_item }
      let(:result) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      before do
        allow(Analysis::Step).to receive(:find_by)
          .with(command_class: command_class).and_return(analysis_step)
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
        allow(current_item).to receive_messages(
          steps_summary: { step_data: 'summary' },
          featurable: { features: 'data' }
        )
      end

      it 'updates analysis_item status to wip initially' do
        # Stop execution before status gets updated to 'done'
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class) do
          expect(analysis_item.reload.status).to eq('wip')

          result
        end
        command.call
      end

      it 'adds the step to current_item' do
        expect { command.call }.to change { current_item.steps.count }.by(1)
        expect(current_item.steps).to include(analysis_step)
      end

      it 'creates and updates item_step with wip status initially' do
        allow(Invoker).to receive(:execute).with(
          :a_step, current_item, command_class
        ) do
          item_step = current_item.item_steps.find_by(step: analysis_step)
          expect(item_step.execution_status).to eq('wip')
          expect(item_step.started_at).to eq(Time.current)

          result
        end
        command.call
      end

      it 'executes the step via Invoker' do
        command.call
        expect(Invoker).to have_received(:execute)
          .with(:a_step, current_item, command_class)
      end

      it 'updates steps_data on analysis_item' do
        command.call
        expect(analysis_item.reload.steps_data)
          .to eq({ 'step_data' => 'summary' })
      end

      it 'syncs the analysis report' do
        command.call
        expect(Invoker).to have_received(:execute).with(
          :analysis_report_sync_command, analysis_report
        )
      end
    end

    context 'when analysis_item has a clone_of' do
      let(:clone_item) { create :analysis_item, :clone }
      let(:current_item) { clone_item.clone_of }
      let(:analysis_item) { clone_item }
      let(:result) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      before do
        allow(Analysis::Step).to receive(:find_by)
          .with(command_class: command_class).and_return(analysis_step)
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
        allow(current_item).to receive(:steps_summary)
          .and_return({ step_data: 'summary' })
      end

      it 'processes the step on the clone_of item' do
        command.call
        expect(current_item.steps).to include(analysis_step)
      end

      it 'updates the clone analysis_item status to done after success' do
        command.call
        expect(analysis_item.reload.status).to eq('done')
      end
    end
  end

  describe 'step execution results' do
    let(:current_item) { analysis_item }

    before do
      allow(Analysis::Step).to receive(:find_by)
        .with(command_class: command_class).and_return(analysis_step)
      allow(current_item).to receive(:steps_summary)
        .and_return({ step_data: 'summary' })
    end

    context 'when result status is success and approved' do
      let(:result) do
        { status: 'success', approved: true, disapproval_situation: nil }
      end

      before do
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
      end

      it 'updates analysis_item status to done' do
        command.call
        expect(analysis_item.reload.status).to eq('done')
      end

      it 'updates item_step to completed status' do
        command.call
        item_step = current_item.item_steps.find_by(step: analysis_step)
        expect(item_step.execution_status).to eq('completed')
        expect(item_step.finished_at).to eq(Time.current)
        expect(item_step.result_summary).to eq(
          {
            'approved' => true,
            'disapproval_situation' => nil
          }
        )
      end
    end

    context 'when result status is success but not approved' do
      let(:result) do
        { status: 'success', approved: false,
          disapproval_situation: :prediction }
      end

      before do
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
      end

      it 'updates analysis_item status to done with disapproval_situation' do
        command.call
        analysis_item.reload
        expect(analysis_item.status).to eq('done')
        expect(analysis_item.disapproval_situation).to eq('prediction')
      end

      context 'when command_class is PrePredictionCommand' do
        let(:command_class) { 'PrePredictionCommand' }

        it 'creates an analysis prediction' do
          expect { command.call }.to change(Analysis::Prediction, :count).by(1)
          prediction = Analysis::Prediction.last
          expect(prediction.label).to eq('pre_prediction')
          expect(prediction.item).to eq(analysis_item)
          expect(prediction.approved).to be false
        end
      end

      context 'when command_class is not PrePredictionCommand' do
        let(:command_class) { 'SomeOtherCommand' }
        let(:analysis_step) do
          create :analysis_step, command_class: command_class
        end

        it 'does not create an analysis prediction' do
          expect { command.call }.not_to change(Analysis::Prediction, :count)
        end
      end
    end

    context 'when result status is failure' do
      let(:result) do
        { status: 'failure', approved: false, disapproval_situation: nil }
      end

      before do
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
      end

      it 'updates analysis_item status to error' do
        command.call
        expect(analysis_item.reload.status).to eq('error')
      end

      it 'updates item_step to failed status' do
        command.call
        item_step = current_item.item_steps.find_by(step: analysis_step)
        expect(item_step.execution_status).to eq('failed')
        expect(item_step.finished_at).to eq(Time.current)
        expect(item_step.result_summary).to eq(
          { 'approved' => false,
            'disapproval_situation' => nil }
        )
      end
    end

    context 'when result status is not_found' do
      let(:result) do
        { status: 'not_found', approved: false, disapproval_situation: nil }
      end

      before do
        allow(Invoker).to receive(:execute)
          .with(:a_step, current_item, command_class).and_return(result)
      end

      it 'updates analysis_item status to not_found' do
        command.call
        expect(analysis_item.reload.status).to eq('not_found')
      end

      it 'updates item_step to completed status' do
        command.call
        item_step = current_item.item_steps.find_by(step: analysis_step)
        expect(item_step.execution_status).to eq('completed')
      end
    end
  end

  describe 'features and prediction command handling' do
    let(:current_item) { analysis_item }
    let(:command_class) { 'Analysis::PredictionCommand' }
    let(:analysis_step) { create :analysis_step, command_class: command_class }
    let(:result) do
      { status: 'success', approved: true, disapproval_situation: nil }
    end

    before do
      allow(Analysis::Step).to receive(:find_by)
        .with(command_class: command_class).and_return(analysis_step)
      allow(Invoker).to receive(:execute)
        .with(:a_step, current_item, command_class).and_return(result)
      allow(current_item).to receive_messages(
        steps_summary: { step_data: 'summary' },
        featurable: { features: 'data' }
      )
      allow(analysis_item).to receive(:done?).and_return(true)
    end

    it 'updates features when item is done and command is PredictionCommand' do
      command.call
      expect(analysis_item.reload.features).to eq({ 'features' => 'data' })
    end
  end
end
