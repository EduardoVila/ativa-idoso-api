# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_address, class: 'Provenir::Address' do
    typology { %w[R C].sample }
    title { Faker::Lorem.word }
    address_main { Faker::Address.street_name }
    number { Faker::Address.building_number }
    complement { Faker::Address.secondary_address }
    neighborhood { Faker::Address.community }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    address_type { %w[WORK HOME].sample }
    address_currently_in_rf_site { Faker::Boolean.boolean }
    complement_type { Faker::Lorem.word }
    build_code { Faker::Lorem.word }
    building_code { Faker::Lorem.word }
    household_code { Faker::Lorem.word }
    address_entity_age { Faker::Number.number(digits: 3) }
    address_entity_total_passages { Faker::Number.number(digits: 2) }
    address_entity_bad_passages { Faker::Number.number(digits: 2) }
    address_entity_crawling_passages { Faker::Number.number(digits: 2) }
    address_entity_validation_passages { Faker::Number.number(digits: 2) }
    address_entity_query_passages { Faker::Number.number(digits: 2) }
    address_entity_month_average_passages { Faker::Number.number(digits: 2) }
    address_global_age { Faker::Number.number(digits: 2) }
    address_global_total_passages { Faker::Number.number(digits: 2) }
    address_global_bad_passages { Faker::Number.number(digits: 2) }
    address_global_crawling_passages { Faker::Number.number(digits: 2) }
    address_global_validation_passages { Faker::Number.number(digits: 2) }
    address_global_query_passages { Faker::Number.number(digits: 2) }
    address_global_month_average_passages { Faker::Number.number(digits: 2) }
    address_number_of_entities { Faker::Number.number(digits: 2) }
    priority { Faker::Number.number(digits: 1) }
    is_main_for_entity { Faker::Boolean.boolean }
    is_recent_for_entity { Faker::Boolean.boolean }
    is_main_for_other_entity { Faker::Boolean.boolean }
    is_recent_for_other_entity { Faker::Boolean.boolean }
    is_active { Faker::Boolean.boolean }
    is_ratified { Faker::Boolean.boolean }
    is_likely_from_accountant { Faker::Boolean.boolean }
    last_validation_date { Faker::Date.backward }
    entity_first_passage_date { Faker::Date.backward }
    entity_last_passage_date { Faker::Date.backward }
    global_first_passage_date { Faker::Date.backward }
    global_last_passage_date { Faker::Date.backward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.backward }
    has_opt_in { Faker::Boolean.boolean }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    extended_address factory: :provenir_extended_address
  end
end
