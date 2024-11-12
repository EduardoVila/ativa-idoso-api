# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_financial_datum,
          class: 'Provenir::FinancialDatum' do
    total_assets { "#{Faker::Number.number(digits: 3)}K A #{Faker::Number.number(digits: 3)}K" }
    creation_date { Faker::Date.backward(days: 365) }
    last_update_date { Faker::Date.backward(days: 365) }

    big_data_corp factory: :provenir_big_data_corp
  end
end
