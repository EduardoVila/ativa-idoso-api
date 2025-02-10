# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#  analysis_step_id :bigint           not null
#
# Indexes
#
#  index_analysis_item_steps_on_analysis_item_id  (analysis_item_id)
#  index_analysis_item_steps_on_analysis_step_id  (analysis_step_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#  fk_rails_...  (analysis_step_id => analysis_steps.id)
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
