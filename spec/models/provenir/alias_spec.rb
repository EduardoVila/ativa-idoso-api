# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_aliases
#
#  id                      :bigint           not null, primary key
#  common_name             :string
#  standardized_name       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_alias_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
require 'spec_helper'

RSpec.describe Provenir::Alias, type: :model do
  describe 'factories' do
    subject { build :provenir_alias }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_basic_datum_id')
        .inverse_of(:alias)
    end
  end
end
