# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_document_informations
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_extended_document_information_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
require 'spec_helper'

RSpec.describe Provenir::ExtendedDocumentInformation, type: :model do
  describe 'factories' do
    subject { build :provenir_extended_document_information }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:extended_document_information)
    end

    it do
      expect(subject).to have_one(:rg)
        .class_name('Provenir::Rg')
        .with_foreign_key('provenir_extended_document_information_id')
        .inverse_of(:extended_document_information)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:rg) }
  end
end
