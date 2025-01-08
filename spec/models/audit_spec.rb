# frozen_string_literal: true

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
