# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_alternative_id_numbers
#
#  id                      :bigint           not null, primary key
#  document_number         :string
#  document_type           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_alternative_id_number_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
require 'spec_helper'

RSpec.describe Provenir::AlternativeIdNumber, type: :model do
  describe 'factories' do
    subject { build :provenir_alternative_id_number }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:alternative_id_number)
    end
  end
end
