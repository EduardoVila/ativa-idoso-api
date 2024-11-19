# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::TrialPart, type: :model do
  describe 'factories' do
    context 'default factory' do
      subject { build :pro_score_trial_part }

      it { is_expected.to be_valid }
    end

    context 'with trait defendant' do
      subject { build :pro_score_trial_part, :defendant }

      it { is_expected.to be_valid }
    end

    context 'with trait plaintiff' do
      subject { build :pro_score_trial_part, :plaintiff }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
