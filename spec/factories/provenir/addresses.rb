# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_addresses
#
#  id                                    :bigint           not null, primary key
#  address_currently_in_rf_site          :string
#  address_entity_age                    :integer
#  address_entity_bad_passages           :integer
#  address_entity_crawling_passages      :integer
#  address_entity_month_average_passages :float
#  address_entity_query_passages         :integer
#  address_entity_total_passages         :integer
#  address_entity_validation_passages    :integer
#  address_global_age                    :integer
#  address_global_bad_passages           :integer
#  address_global_crawling_passages      :integer
#  address_global_month_average_passages :float
#  address_global_query_passages         :integer
#  address_global_total_passages         :integer
#  address_global_validation_passages    :integer
#  address_main                          :string
#  address_number_of_entities            :integer
#  address_type                          :string
#  build_code                            :string
#  building_code                         :string
#  capture_date                          :datetime
#  city                                  :string
#  complement                            :string
#  complement_type                       :string
#  country                               :string
#  creation_date                         :datetime
#  entity_first_passage_date             :datetime
#  entity_last_passage_date              :datetime
#  global_first_passage_date             :datetime
#  global_last_passage_date              :datetime
#  has_opt_in                            :boolean
#  household_code                        :string
#  is_active                             :boolean
#  is_likely_from_accountant             :boolean
#  is_main_for_entity                    :boolean
#  is_main_for_other_entity              :boolean
#  is_ratified                           :boolean
#  is_recent_for_entity                  :boolean
#  is_recent_for_other_entity            :boolean
#  last12_months_passages                :integer          default(0)
#  last16_months_passages                :integer          default(0)
#  last3_months_passages                 :integer          default(0)
#  last6_months_passages                 :integer          default(0)
#  last_update_date                      :datetime
#  last_validation_date                  :datetime
#  latitude                              :float
#  longitude                             :float
#  match_rate                            :integer          default(0)
#  neighborhood                          :string
#  number                                :string
#  priority                              :integer
#  state                                 :string
#  title                                 :string
#  typology                              :string
#  zip_code                              :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  provenir_extended_address_id          :bigint           not null
#
# Indexes
#
#  index_provenir_address_extended_address_id  (provenir_extended_address_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_extended_address_id => provenir_extended_addresses.id)
#
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
