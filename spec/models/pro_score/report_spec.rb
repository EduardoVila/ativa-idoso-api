# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_reports
#
#  id                 :bigint           not null, primary key
#  performed_searches :text             default([]), is an Array
#  raw_data           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  analysis_item_id   :bigint           not null
#
# Indexes
#
#  index_pro_score_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
require 'spec_helper'

RSpec.describe ProScore::Report, type: :model do
  describe 'factories' do
    subject { build :pro_score_report }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :raw_data }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:analysis_item)
        .class_name('Analysis::Item')
    }

    it {
      expect(subject).to have_many(:trials)
        .class_name('ProScore::Trial')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:monthly_benefits)
        .class_name('ProScore::MonthlyBenefit')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:emergency_assistances)
        .class_name('ProScore::EmergencyAssistance')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:family_assistances)
        .class_name('ProScore::FamilyAssistance')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:family_holdings)
        .class_name('ProScore::FamilyHolding')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:bounced_checks)
        .class_name('ProScore::BouncedCheck')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:commercial_relations)
        .class_name('ProScore::CommercialRelation')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_many(:criminal_antecedents)
        .class_name('ProScore::CriminalAntecedent')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_one(:proprable_profession)
        .class_name('ProScore::ProprableProfession')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_one(:presumed_salary_range)
        .class_name('ProScore::PresumedSalaryRange')
        .inverse_of(:report)
    }

    it {
      expect(subject).to have_one(:presumed_income)
        .class_name('ProScore::PresumedIncome')
        .inverse_of(:report)
    }
  end
end
