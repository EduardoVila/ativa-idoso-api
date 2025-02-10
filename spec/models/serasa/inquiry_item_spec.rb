# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiry_items
#
#  id                  :bigint           not null, primary key
#  days_quantity       :integer
#  occurrence_date     :date
#  segment_description :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  serasa_inquiry_id   :bigint           not null
#
# Indexes
#
#  index_serasa_inquiry_items_on_serasa_inquiry_id  (serasa_inquiry_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_inquiry_id => serasa_inquiries.id)
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
