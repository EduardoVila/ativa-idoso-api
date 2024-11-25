# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_basic_data
#
#  id                                   :bigint           not null, primary key
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
#  provenir_big_data_corp_id            :bigint           not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
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
