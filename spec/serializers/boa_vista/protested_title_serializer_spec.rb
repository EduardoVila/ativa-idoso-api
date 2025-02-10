# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :bigint           not null, primary key
#  city                          :string
#  currency                      :string
#  federative_unit               :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  registry                      :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_protested_titles_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
