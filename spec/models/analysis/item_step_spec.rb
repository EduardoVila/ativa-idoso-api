# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :uuid             not null, primary key
#  analysis_item_id :uuid             not null
#  analysis_step_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

RSpec.describe Analysis::ItemStep, type: :model do
  describe 'factories' do
    subject { build(:analysis_item_step) }

    it { is_expected.to be_valid }
  end
end
