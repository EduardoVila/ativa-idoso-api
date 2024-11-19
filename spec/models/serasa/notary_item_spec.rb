# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :uuid             not null, primary key
#  occurrence_date  :date
#  amount           :float
#  office_number    :string
#  office_name      :string
#  city             :string
#  federal_unit     :string
#  serasa_notary_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::NotaryItem, type: :model do
  describe 'factories' do
    subject { build :serasa_notary_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :notary }
  end
end
