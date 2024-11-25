# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_addresses
#
#  id                                    :bigint           not null, primary key
#  typology                              :string
#  title                                 :string
#  address_main                          :string
#  number                                :string
#  complement                            :string
#  neighborhood                          :string
#  zip_code                              :string
#  city                                  :string
#  state                                 :string
#  country                               :string
#  address_type                          :string
#  address_currently_in_rf_site          :string
#  complement_type                       :string
#  build_code                            :string
#  building_code                         :string
#  household_code                        :string
#  address_entity_age                    :integer
#  address_entity_total_passages         :integer
#  address_entity_bad_passages           :integer
#  address_entity_crawling_passages      :integer
#  address_entity_validation_passages    :integer
#  address_entity_query_passages         :integer
#  address_entity_month_average_passages :float
#  address_global_age                    :integer
#  address_global_total_passages         :integer
#  address_global_bad_passages           :integer
#  address_global_crawling_passages      :integer
#  address_global_validation_passages    :integer
#  address_global_query_passages         :integer
#  address_global_month_average_passages :float
#  address_number_of_entities            :integer
#  priority                              :integer
#  is_main_for_entity                    :boolean
#  is_recent_for_entity                  :boolean
#  is_main_for_other_entity              :boolean
#  is_recent_for_other_entity            :boolean
#  is_active                             :boolean
#  is_ratified                           :boolean
#  is_likely_from_accountant             :boolean
#  last_validation_date                  :datetime
#  entity_first_passage_date             :datetime
#  entity_last_passage_date              :datetime
#  global_first_passage_date             :datetime
#  global_last_passage_date              :datetime
#  last3_months_passages                 :integer          default(0)
#  last6_months_passages                 :integer          default(0)
#  last12_months_passages                :integer          default(0)
#  last16_months_passages                :integer          default(0)
#  match_rate                            :integer          default(0)
#  creation_date                         :datetime
#  capture_date                          :datetime
#  last_update_date                      :datetime
#  has_opt_in                            :boolean
#  latitude                              :float
#  longitude                             :float
#  provenir_extended_address_id          :bigint           not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Address, type: :model do
  describe 'factories' do
    subject { build :provenir_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:extended_address)
        .class_name('Provenir::ExtendedAddress')
        .with_foreign_key('provenir_extended_address_id')
        .inverse_of(:addresses)
    end
  end
end
