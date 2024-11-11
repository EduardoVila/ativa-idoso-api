# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::CadastralLocation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral_location }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral) }
    it { is_expected.to have_many(:phones) }
    it { is_expected.to have_many(:addresses) }
  end
end
