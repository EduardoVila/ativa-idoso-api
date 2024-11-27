# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::IncomeEstimateSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:income_estimate) { build :provenir_income_estimate }
  let(:serializer) { described_class.new income_estimate }

  it { is_expected.to serialize_attribute(:id).from(income_estimate) }
  it { is_expected.to serialize_attribute(:ibge).from(income_estimate) }
  it { is_expected.to serialize_attribute(:bigdata).from(income_estimate) }
  it { is_expected.to serialize_attribute(:bigdata_v2).from(income_estimate) }
end
