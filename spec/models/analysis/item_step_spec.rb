# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :bigint           not null, primary key
#  analysis_item_id :uuid             not null
#  analysis_step_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::ItemStep, type: :model do
  describe 'factories' do
    subject { build :analysis_item_step }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:item).class_name('Analysis::Item')
        .with_foreign_key('analysis_item_id')
    }

    it {
      expect(subject).to belong_to(:step).class_name('Analysis::Step')
        .with_foreign_key('analysis_step_id')
    }
  end
end
