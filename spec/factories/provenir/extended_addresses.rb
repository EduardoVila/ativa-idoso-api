# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_extended_address,
          class: 'Provenir::ExtendedAddress' do
    total_addresses { Faker::Number.number(digits: 1) }
    total_active_addresses { Faker::Number.number(digits: 1) }
    total_work_addresses { Faker::Number.number(digits: 1) }
    total_personal_addresses { Faker::Number.number(digits: 1) }
    total_unique_addresses { Faker::Number.number(digits: 1) }
    total_address_passages { Faker::Number.number(digits: 1) }
    total_bad_address_passages { Faker::Number.number(digits: 1) }
    oldest_address_passage_date { Faker::Date.backward }
    newest_address_passage_date { Faker::Date.forward }

    big_data_corp factory: :provenir_big_data_corp
  end
end
