# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::FamilyAssistance, type: :model do
  describe 'factories' do
    subject { build :pro_score_family_assistance }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end
end
