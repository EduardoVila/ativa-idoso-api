# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::MonthlyBenefit, type: :model do
  describe 'factories' do
    subject { build :pro_score_monthly_benefit }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end
end
