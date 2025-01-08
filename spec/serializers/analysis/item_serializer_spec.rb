# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  cpf                   :string
#  status                :integer          default("todo")
#  error_status          :integer          default("none")
#  prediction            :integer
#  payment_situation     :integer          default("unanalyzed")
#  disapproval_situation :integer
#  features              :jsonb
#  clone_of_id           :uuid
#  analysis_report_id    :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::ItemSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:analysis_item) { create :analysis_item }
  let(:serializer) { described_class.new(analysis_item) }

  it { is_expected.to serialize_attribute(:id).from(analysis_item) }
  it { is_expected.to serialize_attribute(:cpf).from(analysis_item) }

  it {
    expect(subject).to serialize_attribute(:disapproval_situation)
      .from(analysis_item)
  }

  it { is_expected.to serialize_attribute(:status).from(analysis_item) }
  it { is_expected.to serialize_attribute(:created_at).from(analysis_item) }
  it { is_expected.to serialize_attribute(:prediction).from(analysis_item) }
  it { is_expected.to serialize_attribute(:error_status).from(analysis_item) }

  describe 'custom attributes' do # rubocop:disable RSpec/EmptyExampleGroup
    # TODO: Implement tests for the custom attributes
  end
end
