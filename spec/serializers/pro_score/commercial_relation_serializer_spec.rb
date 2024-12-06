# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpfcnpj             :string
#  razao_social        :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::CommercialRelationSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:commercial_relation) { build :pro_score_commercial_relation }
  let(:serializer) do
    described_class.new commercial_relation
  end

  it { is_expected.to serialize_attribute(:id).from(commercial_relation) }
  it { is_expected.to serialize_attribute(:cpfcnpj).from(commercial_relation) }

  it do
    expect(subject).to serialize_attribute(:created_at)
      .from(commercial_relation)
  end

  describe 'custom method' do
    describe '#corporate_name' do
      subject { serialized[:corporate_name] }

      it { is_expected.to eq(commercial_relation.razao_social) }
    end
  end
end
