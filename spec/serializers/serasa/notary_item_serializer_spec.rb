# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  amount           :float
#  city             :string
#  federal_unit     :string
#  occurrence_date  :date
#  office_name      :string
#  office_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  serasa_notary_id :bigint           not null
#
# Indexes
#
#  index_serasa_notary_items_on_serasa_notary_id  (serasa_notary_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_notary_id => serasa_notaries.id)
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
