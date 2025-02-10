# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_parties
#
#  id                  :bigint           not null, primary key
#  is_party_active     :boolean
#  last_capture_date   :datetime
#  name                :string
#  party_doc           :string
#  party_type          :string
#  polarity            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_party_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
require 'spec_helper'

RSpec.describe Provenir::Party, type: :model do
  describe 'factories' do
    it { expect(build(:provenir_party)).to be_valid }
    it { expect(build(:provenir_party, :passive)).to be_valid }
    it { expect(build(:provenir_party, :active)).to be_valid }
    it { expect(build(:provenir_party, :neutral)).to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:lawsuit)
        .class_name('Provenir::Lawsuit')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:parties)
    end

    it do
      expect(subject).to have_one(:party_detail)
        .class_name('Provenir::PartyDetail')
        .with_foreign_key('provenir_party_id')
        .inverse_of(:party)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:party_detail) }
  end
end
