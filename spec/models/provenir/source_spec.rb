# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :bigint           not null, primary key
#  ENADE          :string
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  provenir_rg_id :bigint           not null
#
# Indexes
#
#  index_provenir_source_rg_id  (provenir_rg_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_rg_id => provenir_rgs.id)
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
