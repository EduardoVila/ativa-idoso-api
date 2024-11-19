# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::Report, type: :model do
  describe 'factories' do
    subject { build :pro_score_report }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    context 'raw_data' do
      it { is_expected.to validate_presence_of :raw_data }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:score) }

    it { is_expected.to have_many(:trials) }
    it { is_expected.to have_many(:monthly_benefit) }
    it { is_expected.to have_many(:emergency_assistance) }
    it { is_expected.to have_many(:family_assistance) }
    it { is_expected.to have_many(:family_holdings) }
    it { is_expected.to have_many(:bounced_checks) }
    it { is_expected.to have_many(:commercial_relations) }
    it { is_expected.to have_many(:criminal_antecedents) }
    it { is_expected.to have_one(:proprable_profession) }
    it { is_expected.to have_one(:presumed_salary_range) }
    it { is_expected.to have_one(:presumed_income) }
  end
end
