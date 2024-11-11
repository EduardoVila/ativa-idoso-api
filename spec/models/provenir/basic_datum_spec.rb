# frozen_string_literal: true

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
