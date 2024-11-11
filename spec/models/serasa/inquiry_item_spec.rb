# frozen_string_literal: true

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
