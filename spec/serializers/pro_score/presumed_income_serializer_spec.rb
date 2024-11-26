# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::PresumedIncomeSerializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:presumed_income) { build :pro_score_presumed_income }
  let(:serializer) { described_class.new presumed_income }

  it do
    expect(subject).to serialize_attribute(:id).from(presumed_income)
    expect(subject).to serialize_attribute(:created_at).from(presumed_income)
  end

  describe 'custom attributes' do
    describe '#value' do
      subject { serialized[:value] }

      it { is_expected.to eq presumed_income.valor_da_renda_presumida }
    end
  end
end
