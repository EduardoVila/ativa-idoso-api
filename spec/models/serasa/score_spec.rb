# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_scores
#
#  id                       :uuid             not null, primary key
#  score                    :integer
#  score_model              :string
#  range                    :string
#  default_rate             :string
#  code_message             :integer
#  message                  :string
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Score, type: :model do
  describe 'factories' do
    subject { build :serasa_score }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
  end
end
