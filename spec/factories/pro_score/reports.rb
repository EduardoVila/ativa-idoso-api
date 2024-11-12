# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_reports
#
#  id                 :uuid             not null, primary key
#  raw_data           :string
#  performed_searches :text             default([]), is an Array
#  analysis_item_id   :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :pro_score_report, class: 'ProScore::Report' do
    raw_data { 'Lorem ipsum' }

    trait :performed do
      performed_searches do
        %w[
          family_holding bounced_check trial
          presumed_income commercial_relation
        ]
      end
    end

    analysis_item factory: :analysis_item
  end
end
