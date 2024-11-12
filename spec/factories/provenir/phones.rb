# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_phone, class: 'Provenir::Phone' do
    number { Faker::PhoneNumber.cell_phone }
    complement { Faker::Lorem.word }
    area_code { Faker::Number.number(digits: 2) }
    neighborhood { Faker::Address.community }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    phone_type { %w[MOBILE LANDLINE].sample }
    address_currently_in_rf_site { Faker::Lorem.word }
    complement_type { Faker::Lorem.word }
    build_code { Faker::Lorem.word }
    building_code { Faker::Lorem.word }
    household_code { Faker::Lorem.word }
    address_entity_age { Faker::Lorem.word }
    country_code { Faker::Number.number(digits: 2) }
    phone_currently_in_rf_site { Faker::Boolean.boolean }
    phone_entity_total_passages { Faker::Number.number(digits: 2) }
    phone_entity_bad_passages { Faker::Number.number(digits: 2) }
    phone_entity_crawling_passages { Faker::Number.number(digits: 2) }
    phone_entity_validation_passages { Faker::Number.number(digits: 2) }
    phone_entity_query_passages { Faker::Number.number(digits: 2) }
    phone_entity_month_average_passages { Faker::Number.number(digits: 2) }
    phone_global_age { Faker::Number.number(digits: 2) }
    phone_global_total_passages { Faker::Number.number(digits: 2) }
    phone_global_bad_passages { Faker::Number.number(digits: 2) }
    phone_global_crawling_passages { Faker::Number.number(digits: 2) }
    phone_global_validation_passages { Faker::Number.number(digits: 2) }
    phone_global_query_passages { Faker::Number.number(digits: 2) }
    phone_global_month_average_passages { Faker::Number.number(digits: 2) }
    last3_months_passages { Faker::Number.number(digits: 2) }
    last6_months_passages { Faker::Number.number(digits: 2) }
    last12_months_passages { Faker::Number.number(digits: 2) }
    last18_months_passages { Faker::Number.number(digits: 2) }
    phone_number_of_entities { Faker::Number.number(digits: 2) }
    phone_number_of_family_related_entities { Faker::Number.number(digits: 2) }
    phone_number_of_related_entities { Faker::Number.number(digits: 2) }
    priority { Faker::Number.number(digits: 1) }
    is_main_for_entity { Faker::Boolean.boolean }
    is_recent_for_entity { Faker::Boolean.boolean }
    is_main_for_other_entity { Faker::Boolean.boolean }
    is_recent_for_other_entity { Faker::Boolean.boolean }
    is_active { Faker::Boolean.boolean }
    is_likely_from_accountant { Faker::Boolean.boolean }
    is_in_do_not_call_list { Faker::Boolean.boolean }
    current_carrier { Faker::Lorem.word }

    extended_phone factory: :provenir_extended_phone
  end
end
