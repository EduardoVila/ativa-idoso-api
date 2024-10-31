# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProScore::ProprableProfession, type: :model do
  describe 'factories' do
    subject { build :pro_score_proprable_profession }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
  end
end
