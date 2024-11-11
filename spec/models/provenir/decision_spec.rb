# frozen_string_literal: true

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
