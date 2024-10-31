# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_reports
#
#  id                 :bigint           not null, primary key
#  score_id           :bigint           not null
#  raw_data           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  performed_searches :text             default([]), is an Array
#
module ProScore
  class Report < ApplicationRecord
    belongs_to :score

    has_many :trials, class_name: 'ProScore::Trial',
                      dependent: :destroy,
                      foreign_key: 'pro_score_report_id',
                      inverse_of: :report
    has_many :family_assistance, class_name: 'ProScore::FamilyAssistance',
                                 dependent: :destroy,
                                 foreign_key: 'pro_score_report_id',
                                 inverse_of: :report
    has_many :emergency_assistance, class_name: 'ProScore::EmergencyAssistance',
                                    dependent: :destroy,
                                    foreign_key: 'pro_score_report_id',
                                    inverse_of: :report
    has_many :monthly_benefit, class_name: 'ProScore::MonthlyBenefit',
                               dependent: :destroy,
                               foreign_key: 'pro_score_report_id',
                               inverse_of: :report
    has_many :family_holdings, class_name: 'ProScore::FamilyHolding',
                               dependent: :destroy,
                               foreign_key: 'pro_score_report_id',
                               inverse_of: :report
    has_many :bounced_checks, class_name: 'ProScore::BouncedCheck',
                              dependent: :destroy,
                              foreign_key: 'pro_score_report_id',
                              inverse_of: :report
    has_many :commercial_relations, class_name: 'ProScore::CommercialRelation',
                                    dependent: :destroy,
                                    foreign_key: 'pro_score_report_id',
                                    inverse_of: :report
    has_many :criminal_antecedents, class_name: 'ProScore::CriminalAntecedent',
                                    dependent: :destroy,
                                    foreign_key: 'pro_score_report_id',
                                    inverse_of: :report

    has_one :proprable_profession, class_name: 'ProScore::ProprableProfession',
                                   dependent: :destroy,
                                   foreign_key: 'pro_score_report_id',
                                   inverse_of: :report
    has_one :presumed_salary_range, class_name: 'ProScore::PresumedSalaryRange',
                                    dependent: :destroy,
                                    foreign_key: 'pro_score_report_id',
                                    inverse_of: :report
    has_one :presumed_income, class_name: 'ProScore::PresumedIncome',
                              dependent: :destroy,
                              foreign_key: 'pro_score_report_id',
                              inverse_of: :report

    validates :raw_data, presence: true

    def presumed_income_value
      presumed_income&.valor_da_renda_presumida&.delete('.')&.tr(',',
                                                                 '.').to_f
    end

    def trials_approved?
      checked_trials = trials.includes(:parts).map(&:defendant_and_disapproved?)

      checked_trials.exclude? true
    end

    def company?
      commercial_relations.any? ? 1 : 0
    end

    def bounced_check?
      bounced_checks.any?
    end
  end
end
