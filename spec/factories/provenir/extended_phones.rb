# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_extended_phone, class: 'Provenir::ExtendedPhone' do
    total_phones { Faker::Number.number(digits: 1) }
    total_active_phones { Faker::Number.number(digits: 1) }
    total_work_phones { Faker::Number.number(digits: 1) }
    total_personal_phones { Faker::Number.number(digits: 1) }
    total_unique_phones { Faker::Number.number(digits: 1) }
    total_phone_passages { Faker::Number.number(digits: 1) }
    total_bad_phone_passages { Faker::Number.number(digits: 1) }
    total_last3_months_passages { Faker::Number.number(digits: 1) }
    total_last6_months_passages { Faker::Number.number(digits: 1) }
    total_last12_months_passages { Faker::Number.number(digits: 1) }
    total_last18_months_passages { Faker::Number.number(digits: 1) }
    oldest_phone_passage_date { Faker::Date.backward }
    newest_phone_passage_date { Faker::Date.forward }

    big_data_corp factory: :provenir_big_data_corp
  end
end
