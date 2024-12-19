# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::PredictionSerializer, type: :serializer do
  let(:prediction) { create :analysis_prediction }
  let(:serialized_prediction) do
    described_class.new(prediction).serializable_hash
  end

  it 'includes the expected attributes' do
    expect(serialized_prediction).to include(
      :id,
      :label,
      :fee,
      :approved,
      :created_at
    )
  end

  it 'serializes the attributes correctly' do
    expect(serialized_prediction).to serialize_attribute(:id)
      .from(prediction)
    expect(serialized_prediction).to serialize_attribute(:label)
      .from(prediction)
    expect(serialized_prediction).to serialize_attribute(:fee)
      .from(prediction)
    expect(serialized_prediction).to serialize_attribute(:approved)
      .from(prediction)
    expect(serialized_prediction).to serialize_attribute(:created_at)
      .from(prediction)
  end
end
