# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProScore::TrialTopic, type: :model do
  describe 'factories' do
    context 'without disapproved word in title' do
      subject { build :pro_score_trial_topic }

      it { is_expected.to be_valid }
    end

    context 'with disapproved word in title' do
      subject { build :pro_score_trial_topic, :with_disapproved_title }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
