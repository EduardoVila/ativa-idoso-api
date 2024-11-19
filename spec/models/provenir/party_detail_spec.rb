# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_party_details
#
#  id                :uuid             not null, primary key
#  specific_type     :string
#  provenir_party_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::PartyDetail, type: :model do
  describe 'factories' do
    subject { build :provenir_party_detail }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:party)
        .class_name('Provenir::Party')
        .with_foreign_key('provenir_party_id')
        .inverse_of(:party_detail)
    end
  end
end
