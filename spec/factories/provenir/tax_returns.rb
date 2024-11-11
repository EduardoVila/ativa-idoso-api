# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_tax_return, class: 'Provenir::TaxReturn' do
    year { Faker::Date.backward }
    status { %w[CREDITADA DEBITADA].sample }
    bank { Faker::Bank.name }
    branch { Faker::Bank.name }
    batch { Faker::Bank.name }
    is_vip_branch { Faker::Boolean.boolean }
    capture_date { Faker::Date.backward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.backward }

    financial_datum factory: :provenir_financial_datum
  end
end
