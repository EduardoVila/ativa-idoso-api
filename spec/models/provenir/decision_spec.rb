# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_decisions
#
#  id                  :uuid             not null, primary key
#  decision_content    :text
#  decision_date       :datetime
#  provenir_lawsuit_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Decision, type: :model do
  describe 'factories' do
    subject { build :provenir_decision }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:lawsuit)
        .class_name('Provenir::Lawsuit')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:decisions)
    end
  end
end
