# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Delegators::Provenir, '#provenir_income_range_ordinal' do
  # rubocop:enable RSpec/SpecFilePathFormat
  let(:dummy_class) do
    Class.new do
      include Delegators::Provenir

      attr_accessor :provenir_big_data_corp
    end
  end

  let(:dummy_instance) { dummy_class.new }

  let(:financial_risk) { double('FinancialRisk') }
  let(:big_data_corp) do
    double('BigDataCorp', financial_risk: financial_risk)
  end

  before do
    dummy_instance.provenir_big_data_corp = big_data_corp
  end

  {
    '0 A 1 SM' => 1,
    '1 A 2 SM' => 2,
    '2 A 3 SM' => 3,
    '3 A 5 SM' => 4,
    '5 A 7 SM' => 5,
    '7 A 10 SM' => 6,
    '10 A 15 SM' => 7,
    '15 A 20 SM' => 8,
    'ACIMA DE 20 SM' => 9
  }.each do |range, ordinal|
    it "maps '#{range}' to #{ordinal}" do
      allow(financial_risk)
        .to receive(:estimated_income_range)
        .and_return(range)

      expect(dummy_instance.provenir_income_range_ordinal)
        .to eq(ordinal)
    end
  end

  it "maps unknown string 'SEM INFORMACAO' to 0" do
    allow(financial_risk)
      .to receive(:estimated_income_range)
      .and_return('SEM INFORMACAO')

    expect(dummy_instance.provenir_income_range_ordinal).to eq(0)
  end

  it 'maps nil income range to 0' do
    allow(financial_risk)
      .to receive(:estimated_income_range).and_return(nil)

    expect(dummy_instance.provenir_income_range_ordinal).to eq(0)
  end

  it 'returns 0 when financial_risk is nil' do
    allow(big_data_corp)
      .to receive(:financial_risk).and_return(nil)

    expect(dummy_instance.provenir_income_range_ordinal).to eq(0)
  end
end
