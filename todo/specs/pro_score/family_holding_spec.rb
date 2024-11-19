# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::FamilyHolding, type: :model do
  describe 'factories' do
    subject { build :pro_score_family_holding }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end
end
