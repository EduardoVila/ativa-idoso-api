# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_basic_data
#
#  id                                   :bigint           not null, primary key
#  age                                  :integer
#  birth_country                        :string
#  birth_date                           :datetime
#  chinese_sign                         :string
#  creation_date                        :datetime
#  father_name                          :string
#  first_and_last_name_uniqueness_score :integer
#  first_name_uniqueness_score          :integer
#  gender                               :string
#  has_obit_indication                  :boolean
#  last_update_date                     :datetime
#  marital_status_data                  :string
#  mother_name                          :string
#  name                                 :string
#  name_uniqueness_score                :integer
#  name_word_count                      :integer
#  number_of_full_name_namesakes        :integer
#  tax_id_country                       :string
#  tax_id_fiscal_region                 :string
#  tax_id_number                        :string
#  tax_id_origin                        :string
#  tax_id_status                        :string
#  tax_id_status_date                   :datetime
#  tax_id_status_registration_date      :datetime
#  zodiac_sign                          :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  provenir_big_data_corp_id            :bigint           not null
#
# Indexes
#
#  index_provenir_basic_datum_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
module Provenir
  class BasicDatum < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      alternative_id_numbers: :alternative_id_number,
      aliases: :alias
    }.freeze

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

    validates :provenir_big_data_corp_id, uniqueness: true

    accepts_nested_attributes_for :alternative_id_number,
                                  :extended_document_information,
                                  :alias

    alias alternative_id_numbers alternative_id_number
    alias :aliases :alias # symbol to avoid conflict with alias method

    def alternative_id_numbers_attributes=(params)
      self.alternative_id_number_attributes = params
    end

    def aliases_attributes=(params)
      self.alias_attributes = params
    end
  end
end
