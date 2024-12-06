# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  occurrence_date  :date
#  amount           :float
#  office_number    :string
#  office_name      :string
#  city             :string
#  federal_unit     :string
#  serasa_notary_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::NotaryItemSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:notary_item) { build :serasa_notary_item }
  let(:serializer) { described_class.new notary_item }

  it do
    expect(subject).to serialize_attribute(:occurrence_date).from(notary_item)
    expect(subject).to serialize_attribute(:office_number).from(notary_item)
    expect(subject).to serialize_attribute(:office_name).from(notary_item)
    expect(subject).to serialize_attribute(:city).from(notary_item)
    expect(subject).to serialize_attribute(:federal_unit).from(notary_item)
  end

  describe 'custom attributes' do
    describe 'value' do
      subject { serialized[:value] }

      it { is_expected.to eq format('%.2f', notary_item.amount) }
    end
  end
end
