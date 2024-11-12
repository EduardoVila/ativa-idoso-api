# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_financial_risk, class: 'Provenir::FinancialRisk' do
    total_assets { "#{rand(1..999)}K A #{rand(1..999)}K" }
    estimated_income_range { "#{rand(1..99)} A #{rand(1..99)} SM" }
    is_currently_employed { Faker::Boolean.boolean }
    is_currently_owner { Faker::Boolean.boolean }
    last_occupation_start_date { Faker::Date.backward }
    is_currently_on_collection { Faker::Boolean.boolean }
    last365_days_collection_occurrences { Faker::Number.number(digits: 1) }
    current_consecutive_collection_months { Faker::Number.number(digits: 1) }
    is_currently_receiving_assistance { Faker::Boolean.boolean }
    financial_risk_score { Faker::Number.number(digits: 3) }
    financial_risk_level { Faker::Lorem.word }

    big_data_corp factory: :provenir_big_data_corp
  end
end
