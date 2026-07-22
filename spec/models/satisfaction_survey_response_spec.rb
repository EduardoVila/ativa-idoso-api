require 'spec_helper'

RSpec.describe SatisfactionSurveyResponse, type: :model do
  describe 'factory' do
    subject { build :satisfaction_survey_response }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    described_class::SCORES.each do |score|
      it { is_expected.to validate_inclusion_of(score).in_range(1..5) }
    end

    it { is_expected.to validate_uniqueness_of(:user_id) }
  end

  it 'sets submitted_at automatically' do
    response = build(:satisfaction_survey_response, submitted_at: nil)

    response.validate

    expect(response.submitted_at).to be_present
  end
end
