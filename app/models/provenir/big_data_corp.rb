# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_big_data_corps
#
#  id         :bigint           not null, primary key
#  raw_data   :string
#  score_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_relative '../concerns/blank_object_filterable'

module Provenir
  class BigDataCorp < ApplicationRecord
    include BlankObjectFilterable

    belongs_to :analysis_item, class_name: 'Analysis::Item',
                               foreign_key: 'analysis_item_id'

    has_one :basic_datum,
            class_name: 'Provenir::BasicDatum',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :extended_address,
            class_name: 'Provenir::ExtendedAddress',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :extended_phone,
            class_name: 'Provenir::ExtendedPhone',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :financial_datum,
            class_name: 'Provenir::FinancialDatum',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :financial_risk,
            class_name: 'Provenir::FinancialRisk',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :process,
            class_name: 'Provenir::Process',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :related_person,
            class_name: 'Provenir::RelatedPerson',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :collection,
            class_name: 'Provenir::Collection',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    has_one :business_relationship,
            class_name: 'Provenir::BusinessRelationship',
            foreign_key: 'provenir_big_data_corp_id',
            inverse_of: :big_data_corp,
            dependent: :destroy

    accepts_nested_attributes_for :basic_datum, allow_destroy: true
    accepts_nested_attributes_for :extended_address, allow_destroy: true
    accepts_nested_attributes_for :extended_phone, allow_destroy: true
    accepts_nested_attributes_for :financial_datum, allow_destroy: true
    accepts_nested_attributes_for :financial_risk, allow_destroy: true
    accepts_nested_attributes_for :process, allow_destroy: true
    accepts_nested_attributes_for :related_person, allow_destroy: true
    accepts_nested_attributes_for :collection, allow_destroy: true
    accepts_nested_attributes_for :business_relationship, allow_destroy: true

    alias_method :basic_data, :basic_datum
    alias_method :extended_addresses, :extended_address
    alias_method :extended_phones, :extended_phone
    alias_method :finantial_data, :financial_datum
    alias_method :processes, :process
    alias_method :related_people, :related_person
    alias_method :collections, :collection
    alias_method :business_relationships, :business_relationship

    # Adds helpers to create nested associations via `#{association}_attributes`
    # It is needed in order to create nested associations with alias.
    # This is possible with `#{association}_attributes=value` method
    # provided by `accepts_nested_attributes_for :association`
    # Required to import Big Data Corp data from Provenir API
    def basic_data_attributes=(params)
      self.basic_datum_attributes = params
    end

    def extended_addresses_attributes=(params)
      self.extended_address_attributes = params
    end

    def extended_phones_attributes=(params)
      self.extended_phone_attributes = params
    end

    def finantial_data_attributes=(params)
      self.financial_datum_attributes = params
    end

    def processes_attributes=(params)
      self.process_attributes = params
    end

    def related_people_attributes=(params)
      self.related_person_attributes = params
    end

    def collections_attributes=(params)
      self.collection_attributes = params
    end

    def business_relationships_attributes=(params)
      self.business_relationship_attributes = params
    end
  end
end
