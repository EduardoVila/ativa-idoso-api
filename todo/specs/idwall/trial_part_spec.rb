# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idwall::TrialPart, type: :model do
  describe 'factories' do
    subject { build :idwall_trial_part }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_trial).optional }
  end
end
