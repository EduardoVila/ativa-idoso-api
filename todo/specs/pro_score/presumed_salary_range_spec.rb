# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProScore::PresumedSalaryRange, type: :model do
  describe 'factories' do
    subject { build :pro_score_presumed_salary_range }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end
end
