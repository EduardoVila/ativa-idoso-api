# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :bigint           not null, primary key
#  mte                         :string
#  company_ownership           :string
#  ibge                        :string
#  bigdata                     :string
#  bigdata_v2                  :string
#  provenir_financial_datum_id :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
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
