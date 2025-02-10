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
require 'spec_helper'

RSpec.describe Provenir::BasicDatum, type: :model do
  describe 'factories' do
    subject { build :provenir_basic_datum }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:basic_datum)
    end

    it do
      expect(subject).to have_one(:alternative_id_number)
        .class_name('Provenir::AlternativeIdNumber')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:basic_datum)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:extended_document_information)
        .class_name('Provenir::ExtendedDocumentInformation')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:basic_datum)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:alias)
        .class_name('Provenir::Alias')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:basic_datum)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:alternative_id_number) }

    it do
      expect(subject).to accept_nested_attributes_for(
        :extended_document_information
      )
    end

    it { is_expected.to accept_nested_attributes_for(:alias) }
  end
end
