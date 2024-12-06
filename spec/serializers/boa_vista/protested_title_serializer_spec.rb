# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  registry                      :string
#  occurrence_date               :string
#  currency                      :string
#  value                         :string
#  city                          :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::ProtestedTitleSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:protested_title) { build :boa_vista_protested_title }
  let(:serializer) { described_class.new protested_title }

  it do
    expect(subject).to serialize_attribute(:occurrence_type)
      .from(protested_title)
  end

  it { is_expected.to serialize_attribute(:registry).from(protested_title) }
  it { is_expected.to serialize_attribute(:city).from(protested_title) }

  it do
    expect(subject).to serialize_attribute(:federative_unit)
      .from(protested_title)
  end

  describe 'custom attributes' do
    describe '#value' do
      subject { serialized[:value] }

      it { is_expected.to eq(protested_title.value.to_f) }
    end

    describe '#occurrence_date' do
      subject { serialized[:occurrence_date] }

      it { is_expected.to eq(protested_title.occurrence_date.to_date) }
    end
  end
end
