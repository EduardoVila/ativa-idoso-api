# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiries
#
#  id             :uuid             not null, primary key
#  serasa_fact_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Inquiry, type: :model do
  describe 'factories' do
    subject { build :serasa_inquiry }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fact }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
