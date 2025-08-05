# frozen_string_literal: true

require 'spec_helper'

class Step1
  def serialize_record
    { id: 1, name: 'step1', index_order: 1 }
  end
end

class Step2
  def serialize_record
    { id: 2, name: 'step2', index_order: 2 }
  end
end

class Step3
  def serialize_record
    { id: 3, name: 'step3', index_order: 3 }
  end
end

class ExecutedStep
  def serialize_record
    { id: 1, name: 'step1', index_order: 1 }
  end
end

class ExecutedStep2
  def serialize_record
    { id: 2, name: 'step2', index_order: 2 }
  end
end

RSpec.describe Analysis::StepTrackable do
  let(:dummy_class) do
    Class.new do
      include Analysis::StepTrackable

      attr_accessor :steps, :steps_data

      def initialize
        @steps = []
        @steps_data = {}
      end

      def update(attributes)
        attributes.each { |key, value| send("#{key}=", value) }
      end
    end
  end

  let(:trackable_instance) { dummy_class.new }

  let(:step1) do
    Step1.new
  end
  let(:step2) do
    Step2.new
  end
  let(:step3) do
    Step3.new
  end
  let(:executed_step) do
    ExecutedStep.new
  end

  before do
    # Mock Analysis::Step.enabled.order(:index_order)
    allow(Analysis::Step).to receive_message_chain(:enabled, :order)
      .with(:index_order).and_return([step1, step2, step3])
  end

  describe '#available_analysis_steps' do
    it 'returns serialized records of enabled steps ordered by index' do
      expect(trackable_instance.available_analysis_steps).to eq([
        { id: 1, name: 'step1', index_order: 1 },
        { id: 2, name: 'step2', index_order: 2 },
        { id: 3, name: 'step3', index_order: 3 }
      ])
    end
  end

  describe '#executed_analysis_steps' do
    context 'when no steps are executed' do
      it 'returns empty array' do
        expect(trackable_instance.executed_analysis_steps).to eq([])
      end
    end

    context 'when steps are executed' do
      before do
        trackable_instance.steps = [executed_step]
      end

      it 'returns serialized records of executed steps' do
        expect(trackable_instance.executed_analysis_steps).to eq([
          { id: 1, name: 'step1', index_order: 1 }
        ])
      end
    end
  end

  describe '#pending_analysis_steps' do
    context 'when no steps are executed' do
      it 'returns all available steps' do
        expect(trackable_instance.pending_analysis_steps).to eq([
          { id: 1, name: 'step1', index_order: 1 },
          { id: 2, name: 'step2', index_order: 2 },
          { id: 3, name: 'step3', index_order: 3 }
        ])
      end
    end

    context 'when some steps are executed' do
      before do
        trackable_instance.steps = [executed_step]
      end

      it 'returns only pending steps' do
        expect(trackable_instance.pending_analysis_steps).to eq([
          { id: 2, name: 'step2', index_order: 2 },
          { id: 3, name: 'step3', index_order: 3 }
        ])
      end
    end
  end

  describe '#next_analysis_step' do
    context 'when no steps are pending' do
      before do
        trackable_instance.steps = [step1, step2, step3]

        allow(trackable_instance).to receive(:pending_analysis_steps)
          .and_return([])
      end

      it 'returns empty array' do
        expect(trackable_instance.next_analysis_step).to eq([])
      end
    end

    context 'when steps are pending' do
      before do
        allow(trackable_instance).to receive(:pending_analysis_steps)
          .and_return(
            [
              { id: 2, name: 'step2', index_order: 2 },
              { id: 3, name: 'step3', index_order: 3 }
            ]
          )
      end

      it 'returns the first pending step' do
        expect(trackable_instance.next_analysis_step)
          .to eq({ id: 2, name: 'step2', index_order: 2 })
      end
    end
  end

  describe '#last_analysis_executed_step' do
    context 'when no steps are executed' do
      it 'returns empty array' do
        expect(trackable_instance.last_analysis_executed_step).to eq([])
      end
    end

    context 'when steps are executed' do
      let(:executed_step2) do
        instance_double(
          ExecutedStep2,
          serialize_record: { id: 2, name: 'step2', index_order: 2 }
        )
      end

      before do
        trackable_instance.steps = [executed_step, executed_step2]
      end

      it 'returns the last executed step' do
        expect(trackable_instance.last_analysis_executed_step)
          .to eq({ id: 2, name: 'step2', index_order: 2 })
      end
    end
  end

  describe '#steps_summary' do
    before do
      trackable_instance.steps = [executed_step]
    end

    let(:summary) { trackable_instance.steps_summary }

    it 'returns a hash with all step information' do
      expect(summary[:available_analysis_steps])
        .to eq(trackable_instance.available_analysis_steps)
      expect(summary[:executed_analysis_steps])
        .to eq(trackable_instance.executed_analysis_steps)
      expect(summary[:pending_analysis_steps])
        .to eq(trackable_instance.pending_analysis_steps)
      expect(summary[:next_analysis_step])
        .to eq(trackable_instance.next_analysis_step)
      expect(summary[:last_analysis_executed_step])
        .to eq(trackable_instance.last_analysis_executed_step)
    end

    it 'returns a hash with the correct keys' do
      expect(summary).to include(
        :available_analysis_steps,
        :executed_analysis_steps,
        :pending_analysis_steps,
        :next_analysis_step,
        :last_analysis_executed_step
      )
    end
  end

  describe '#update_steps_data' do
    it 'updates the steps_data attribute with steps_summary' do
      summary = { test: 'data' }

      allow(trackable_instance).to receive(:steps_summary).and_return(summary)

      trackable_instance.update_steps_data

      expect(trackable_instance.steps_data).to eq(summary)
    end
  end
end
