# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_nature_id :string
#  legal_nature    :string
#  contract_id     :string
#  creditor_name   :string
#  amount          :float
#  city            :string
#  federal_unit    :string
#  principal       :boolean
#  owner_type      :string
#  owner_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::NegativeItemSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:negative_item) { build :serasa_negative_item }
  let(:serializer) { described_class.new negative_item }

  it do
    expect(subject).to serialize_attribute(:occurrence_date).from(negative_item)
  end

  describe 'custom attributes' do
    describe '#informant' do
      subject { serialized[:informant] }

      it { is_expected.to eq negative_item.creditor_name }
    end

    describe '#segment' do
      subject { serialized[:segment] }

      it { is_expected.to eq negative_item.legal_nature }
    end

    describe '#value' do
      subject { serialized[:value] }

      it { is_expected.to eq format('%.2f', negative_item.amount) }
    end
  end
end
