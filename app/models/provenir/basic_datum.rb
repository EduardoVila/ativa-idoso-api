# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_basic_data
#
#  id                                   :uuid             not null, primary key
#  tax_id_number                        :string
#  tax_id_country                       :string
#  name                                 :string
#  gender                               :string
#  name_word_count                      :integer
#  number_of_full_name_namesakes        :integer
#  name_uniqueness_score                :integer
#  first_name_uniqueness_score          :integer
#  first_and_last_name_uniqueness_score :integer
#  birth_date                           :datetime
#  age                                  :integer
#  zodiac_sign                          :string
#  chinese_sign                         :string
#  birth_country                        :string
#  mother_name                          :string
#  father_name                          :string
#  marital_status_data                  :string
#  tax_id_status                        :string
#  tax_id_origin                        :string
#  tax_id_fiscal_region                 :string
#  has_obit_indication                  :boolean
#  tax_id_status_date                   :datetime
#  tax_id_status_registration_date      :datetime
#  creation_date                        :datetime
#  last_update_date                     :datetime
#  provenir_big_data_corp_id            :uuid             not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
module Provenir
  class BasicDatum < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :basic_datum

    has_one :alternative_id_number,
            class_name: 'Provenir::AlternativeIdNumber',
            foreign_key: 'provenir_basic_datum_id',
            inverse_of: :basic_datum,
            dependent: :destroy

    has_one :extended_document_information,
            class_name: 'Provenir::ExtendedDocumentInformation',
            foreign_key: 'provenir_basic_datum_id',
            inverse_of: :basic_datum,
            dependent: :destroy

    has_one :alias,
            class_name: 'Provenir::Alias',
            foreign_key: 'provenir_basic_datum_id',
            inverse_of: :basic_datum,
            dependent: :destroy

    accepts_nested_attributes_for :alternative_id_number,
                                  :extended_document_information,
                                  :alias

    alias_attribute :alternative_id_numbers, :alternative_id_number
    alias_attribute :aliases, :alias

    def alternative_id_numbers_attributes=(params)
      self.alternative_id_number_attributes = params
    end

    def aliases_attributes=(params)
      self.alias_attributes = params
    end
  end
end
