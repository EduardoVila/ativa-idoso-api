# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::Address, type: :model do
  describe 'factories' do
    subject { build :boa_vista_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral_location) }
  end
end
