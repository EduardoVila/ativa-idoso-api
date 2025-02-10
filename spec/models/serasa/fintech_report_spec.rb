# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_serasa_fintech_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
require 'spec_helper'

RSpec.describe Serasa::FintechReport, type: :model do
  describe 'factories' do
    subject { build :serasa_fintech_report }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    subject { create :serasa_fintech_report }

    it {
      expect(subject).to validate_uniqueness_of(:analysis_item_id)
        .ignoring_case_sensitivity
    }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
    it { is_expected.to have_one :registration }
    it { is_expected.to have_one :negative_data }
    it { is_expected.to have_one :score }
    it { is_expected.to have_one :fact }
  end
end
