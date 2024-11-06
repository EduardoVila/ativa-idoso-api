# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProScore::TrialLawyer, type: :model do
  describe 'factories' do
    subject { build :pro_score_trial_lawyer }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
