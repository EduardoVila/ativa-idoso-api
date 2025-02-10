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
module Provenir
  class Address < ApplicationRecord
    belongs_to :extended_address,
               class_name: 'Provenir::ExtendedAddress',
               foreign_key: 'provenir_extended_address_id',
               inverse_of: :addresses

    alias_attribute :type, :address_type
  end
end
