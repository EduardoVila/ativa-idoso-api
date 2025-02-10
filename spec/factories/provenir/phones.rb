# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_phones
#
#  id                                      :bigint           not null, primary key
#  address_currently_in_rf_site            :string
#  address_entity_age                      :string
#  area_code                               :string
#  build_code                              :string
#  building_code                           :string
#  capture_date                            :datetime
#  city                                    :string
#  complement                              :string
#  complement_type                         :string
#  country                                 :string
#  country_code                            :string
#  creation_date                           :datetime
#  current_carrier                         :string
#  first_passage_date_for_entity           :datetime
#  first_passage_date_global               :datetime
#  has_opt_in                              :boolean          default(FALSE)
#  household_code                          :string
#  is_active                               :boolean
#  is_in_do_not_call_list                  :boolean
#  is_likely_from_accountant               :boolean
#  is_main_for_entity                      :boolean
#  is_main_for_other_entity                :boolean
#  is_recent_for_entity                    :boolean
#  is_recent_for_other_entity              :boolean
#  last12_months_passages                  :integer
#  last16_months_passages                  :integer          default(0)
#  last18_months_passages                  :integer
#  last3_months_passages                   :integer
#  last6_months_passages                   :integer
#  last_passage_date_for_entity            :datetime
#  last_passage_date_global                :datetime
#  last_validation_date                    :datetime
#  neighborhood                            :string
#  number                                  :string
#  phone_currently_in_rf_site              :boolean
#  phone_entity_bad_passages               :integer
#  phone_entity_crawling_passages          :integer
#  phone_entity_month_average_passages     :float
#  phone_entity_query_passages             :integer
#  phone_entity_total_passages             :integer
#  phone_entity_validation_passages        :integer
#  phone_global_age                        :integer
#  phone_global_bad_passages               :integer
#  phone_global_crawling_passages          :integer
#  phone_global_month_average_passages     :float
#  phone_global_query_passages             :integer
#  phone_global_total_passages             :integer
#  phone_global_validation_passages        :integer
#  phone_number_of_entities                :integer
#  phone_number_of_family_related_entities :integer
#  phone_number_of_related_entities        :integer
#  phone_type                              :string
#  portability_history                     :string           default("")
#  priority                                :integer
#  state                                   :string
#  type_of_phone_plan                      :string           default("")
#  validation_status                       :string           default("")
#  zip_code                                :string
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  provenir_extended_phone_id              :bigint           not null
#
# Indexes
#
#  index_provenir_phone_extended_phone_id  (provenir_extended_phone_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_extended_phone_id => provenir_extended_phones.id)
#
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
