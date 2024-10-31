# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::Address, type: :model do
  context 'factories' do
    subject { build :serasa_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :registration }
  end
end
