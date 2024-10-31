# frozen_string_literal: true

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

    score
  end
end
