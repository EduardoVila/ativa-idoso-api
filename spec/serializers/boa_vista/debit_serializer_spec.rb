# frozen_string_literal: true

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
