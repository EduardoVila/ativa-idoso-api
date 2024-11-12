# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_rg, class: 'Provenir::Rg' do
    document_last4_digits { Faker::Number.number(digits: 4).to_s }
    creation_date { Faker::Date.in_date_period }
    last_update_date { Faker::Date.in_date_period }

    extended_document_information(
      factory: :provenir_extended_document_information
    )
  end
end
