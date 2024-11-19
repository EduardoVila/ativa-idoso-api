# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :uuid             not null, primary key
#  state          :string
#  ENADE          :string
#  provenir_rg_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Source, type: :model do
  describe 'factories' do
    subject { build :provenir_source }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:rg)
        .class_name('Provenir::Rg')
        .with_foreign_key('provenir_rg_id')
        .inverse_of(:source)
    end
  end
end
