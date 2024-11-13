# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :uuid             not null, primary key
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
#  owner_id        :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::NegativeItem, type: :model do
  describe 'factories' do
    subject { build :serasa_negative_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
  end

  describe 'scopes' do
    context 'when it is current_semester' do
      let!(:current_semester_item) do
        create :serasa_negative_item, occurrence_date: Time.zone.today
      end
      let!(:old_item) do
        create(
          :serasa_negative_item, occurrence_date: Time.zone.today - 7.months
        )
      end

      it 'returns items filtered by occurrence date of current semester' do
        expect(described_class.current_semester).to contain_exactly(
          current_semester_item
        )
      end
    end
  end

  describe '#disapproved?' do
    context 'when is disapproved' do
      subject { create :serasa_negative_item, creditor_name: 'SINISTRO' }

      it 'returns true' do
        expect(subject).to be_disapproved
      end
    end

    context 'when is approved' do
      subject { create :serasa_negative_item, creditor_name: 'FOO' }

      it 'returns false' do
        expect(subject).not_to be_disapproved
      end
    end
  end
end
