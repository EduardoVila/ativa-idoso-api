# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  approved         :boolean
#  cpf              :string
#  fee              :float
#  input_data       :jsonb
#  label            :string
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#
# Indexes
#
#  index_analysis_predictions_on_analysis_item_id  (analysis_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
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
