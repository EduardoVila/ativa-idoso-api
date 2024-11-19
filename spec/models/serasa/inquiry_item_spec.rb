# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiry_items
#
#  id                  :uuid             not null, primary key
#  occurrence_date     :date
#  days_quantity       :integer
#  segment_description :string
#  serasa_inquiry_id   :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::InquiryItem, type: :model do
  describe 'factories' do
    subject { build :serasa_inquiry_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :inquiry }
  end
end
