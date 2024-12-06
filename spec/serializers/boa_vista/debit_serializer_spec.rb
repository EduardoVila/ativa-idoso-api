# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  occurrence_date               :string
#  contract                      :string
#  availability_date             :string
#  currency                      :string           default("0")
#  value                         :string
#  condition                     :string
#  informant                     :string
#  segment                       :string
#  informed_by_querent           :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::DebitSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:debit) { build :boa_vista_debit }
  let(:serializer) { described_class.new debit }

  it { is_expected.to serialize_attribute(:informant).from(debit) }
  it { is_expected.to serialize_attribute(:segment).from(debit) }

  describe 'custom attributes' do
    describe '#value' do
      subject { serialized[:value] }

      it { is_expected.to eq(debit.value.to_f) }
    end

    describe '#occurrence_date' do
      subject { serialized[:occurrence_date] }

      it { is_expected.to eq(debit.occurrence_date.to_date) }
    end
  end
end
