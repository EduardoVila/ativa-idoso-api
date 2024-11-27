# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_phones
#
#  id                           :bigint           not null, primary key
#  total_phones                 :integer
#  total_active_phones          :integer
#  total_work_phones            :integer
#  total_personal_phones        :integer
#  total_unique_phones          :integer
#  total_phone_passages         :integer
#  total_bad_phone_passages     :integer
#  total_last3_months_passages  :integer
#  total_last6_months_passages  :integer
#  total_last12_months_passages :integer
#  total_last16_months_passages :integer          default(0)
#  total_last18_months_passages :integer
#  oldest_phone_passage_date    :datetime
#  newest_phone_passage_date    :datetime
#  provenir_big_data_corp_id    :bigint           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::ExtendedPhone, type: :model do
  describe 'factories' do
    subject { build :provenir_extended_phone }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to have_many(:phones)
        .class_name('Provenir::Phone')
        .with_foreign_key('provenir_extended_phone_id')
        .inverse_of(:extended_phone)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:phones) }
  end
end
