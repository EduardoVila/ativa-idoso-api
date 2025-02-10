# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :bigint           not null, primary key
#  creation_date                             :datetime
#  document_last4_digits                     :string
#  last_update_date                          :datetime
#  number                                    :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  provenir_extended_document_information_id :bigint           not null
#
# Indexes
#
#  index_big_data_rg_extended_document_information_id  (provenir_extended_document_information_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_extended_document_information_id => provenir_extended_document_informations.id)
#
require 'spec_helper'

RSpec.describe Provenir::Rg, type: :model do
  describe 'factories' do
    subject { build :provenir_rg }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:extended_document_information)
        .class_name('Provenir::ExtendedDocumentInformation')
        .with_foreign_key('provenir_extended_document_information_id')
        .inverse_of(:rg)
    end

    it do
      expect(subject).to have_one(:source)
        .class_name('Provenir::Source')
        .with_foreign_key('provenir_rg_id')
        .inverse_of(:rg)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:source) }
  end
end
