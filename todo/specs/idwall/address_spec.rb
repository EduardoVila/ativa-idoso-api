# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idwall::Address, type: :model do
  describe 'factories' do
    subject { build :idwall_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_report) }
  end
end
