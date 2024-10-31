# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::Score, type: :model do
  context 'factories' do
    subject { build :serasa_score }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
  end
end
