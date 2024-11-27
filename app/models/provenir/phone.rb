# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_phones
#
#  id                                      :bigint           not null, primary key
#  number                                  :string
#  complement                              :string
#  area_code                               :string
#  neighborhood                            :string
#  zip_code                                :string
#  city                                    :string
#  state                                   :string
#  country                                 :string
#  phone_type                              :string
#  address_currently_in_rf_site            :string
#  complement_type                         :string
#  build_code                              :string
#  building_code                           :string
#  household_code                          :string
#  address_entity_age                      :string
#  country_code                            :string
#  type_of_phone_plan                      :string           default("")
#  portability_history                     :string           default("")
#  validation_status                       :string           default("")
#  last_validation_date                    :datetime
#  first_passage_date_for_entity           :datetime
#  last_passage_date_for_entity            :datetime
#  first_passage_date_global               :datetime
#  last_passage_date_global                :datetime
#  creation_date                           :datetime
#  capture_date                            :datetime
#  phone_currently_in_rf_site              :boolean
#  phone_entity_total_passages             :integer
#  phone_entity_bad_passages               :integer
#  phone_entity_crawling_passages          :integer
#  phone_entity_validation_passages        :integer
#  phone_entity_query_passages             :integer
#  phone_entity_month_average_passages     :float
#  phone_global_age                        :integer
#  phone_global_total_passages             :integer
#  phone_global_bad_passages               :integer
#  phone_global_crawling_passages          :integer
#  phone_global_validation_passages        :integer
#  phone_global_query_passages             :integer
#  phone_global_month_average_passages     :float
#  last3_months_passages                   :integer
#  last6_months_passages                   :integer
#  last12_months_passages                  :integer
#  last16_months_passages                  :integer          default(0)
#  last18_months_passages                  :integer
#  phone_number_of_entities                :integer
#  phone_number_of_family_related_entities :integer
#  phone_number_of_related_entities        :integer
#  priority                                :integer
#  is_main_for_entity                      :boolean
#  is_recent_for_entity                    :boolean
#  is_main_for_other_entity                :boolean
#  is_recent_for_other_entity              :boolean
#  is_active                               :boolean
#  is_likely_from_accountant               :boolean
#  is_in_do_not_call_list                  :boolean
#  has_opt_in                              :boolean          default(FALSE)
#  current_carrier                         :string
#  provenir_extended_phone_id              :bigint           not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#
module Provenir
  class Phone < ApplicationRecord
    belongs_to :extended_phone,
               class_name: 'Provenir::ExtendedPhone',
               foreign_key: 'provenir_extended_phone_id',
               inverse_of: :phones

    alias_attribute :type, :phone_type
  end
end
