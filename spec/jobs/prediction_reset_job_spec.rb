# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe PredictionResetJob, type: :job do
  let(:report_id) { 123 }
  let(:report) { double('Analysis::Report') }
  let(:item1) { double('Analysis::Item', id: 1, steps_summary: 'summary1') }
  let(:item2) { double('Analysis::Item', id: 2, steps_summary: 'summary2') }
  let(:items_assoc) { double('items association') }
  let(:prediction_step) { double('Analysis::Step', id: 99) }
  let(:item_step_relation) { double('relation', delete_all: 2) }

  before do
    allow(Analysis::Report).to receive(:find)
      .with(report_id).and_return(report)
    allow(Analysis::Step).to receive(:find_by!)
      .with(name: 'predictions').and_return(prediction_step)

    allow(items_assoc).to receive(:pluck).with(:id).and_return([1, 2])
    allow(items_assoc).to receive(:each).and_yield(item1).and_yield(item2)

    allow(Analysis::ItemStep).to receive(:where)
      .and_return(item_step_relation)

    allow(report).to receive_messages(items: items_assoc, update: true,
                                      reload: report)

    allow(item1).to receive(:update)
    allow(item2).to receive(:update)
  end

  it 'removes prediction item steps, updates report/items and re-runs items' do
    expect(Analysis::ItemStep).to receive(:where).with(
      analysis_item_id: [1, 2],
      analysis_step_id: prediction_step.id
    ).and_return(item_step_relation)

    expect(item_step_relation).to receive(:delete_all)

    expect(report).to receive(:update)
      .with(status: :todo, prediction_model_name: 'control')

    expect(item1).to receive(:update)
      .with(status: :todo, steps_data: item1.steps_summary)
    expect(item2).to receive(:update)
      .with(status: :todo, steps_data: item2.steps_summary)

    expect(Invoker).to receive(:execute)
      .with(:analysis_item_runner_command, item1)
    expect(Invoker).to receive(:execute)
      .with(:analysis_item_runner_command, item2)

    described_class.new.perform(report_id, 'control')
  end
end
