# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_aliases
#
#  id                      :uuid             not null, primary key
#  common_name             :string
#  standardized_name       :string
#  provenir_basic_datum_id :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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
