# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::PresumedIncomeSerializer do
  subject(:serialized) { serializer.serializable_hash }

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
