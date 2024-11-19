# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_facts
#
#  id                       :uuid             not null, primary key
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Fact, type: :model do
  describe 'factories' do
    subject { build :serasa_fact }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
    it { is_expected.to have_one :inquiry }
    it { is_expected.to have_one :stolen_document }
  end
end
