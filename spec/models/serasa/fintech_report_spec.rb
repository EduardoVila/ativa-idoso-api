# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :uuid             not null, primary key
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::FintechReport, type: :model do
  describe 'factories' do
    subject { build :serasa_fintech_report }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
    it { is_expected.to have_one :registration }
    it { is_expected.to have_one :negative_data }
    it { is_expected.to have_one :score }
    it { is_expected.to have_one :fact }
  end
end
