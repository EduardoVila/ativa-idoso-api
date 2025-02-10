# frozen_string_literal: true

# == Schema Information
#
# Table name: audits
#
#  id         :bigint           not null, primary key
#  class_name :string           not null
#  event      :string           not null
#  ip         :string
#  item_type  :string           not null
#  object     :text
#  owner_type :string
#  user_agent :string
#  whodunnit  :string
#  created_at :datetime
#  item_id    :integer          not null
#  owner_id   :bigint
#
# Indexes
#
#  index_audits_on_class_name             (class_name)
#  index_audits_on_item_type_and_item_id  (item_type,item_id)
#  index_audits_on_owner                  (owner_type,owner_id)
#
require 'spec_helper'

RSpec.describe Audit, type: :model do
  describe 'factories' do
    subject { build :audit }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner).optional }
  end

  describe 'scopes' do
    describe '#with_owner' do
      before do
        create_list :audit, 10, owner_id: nil
        create_list :audit, 3
      end

      it 'returns just audits with owner' do
        expect(described_class.count).to eq(13)
        expect(described_class.with_owner.count).to eq(3)
      end
    end
  end
end
