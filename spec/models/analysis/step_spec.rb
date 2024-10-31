# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_steps
#
#  id            :uuid             not null, primary key
#  name          :string
#  command_class :integer
#  index_order   :integer
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::Step, type: :model do
  describe 'factories' do
    subject { build :analysis_step }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to have_many(:item_steps).class_name('Analysis::ItemStep')
        .inverse_of(:step)
    }

    it {
      expect(subject).to have_many(:items).through(:item_steps)
        .class_name('Analysis::Item').inverse_of(:steps)
    }
  end
end
