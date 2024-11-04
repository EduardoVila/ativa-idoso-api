# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::Cadastral, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:consumer).optional }
    it { is_expected.to have_one(:cadastral_location) }
    it { is_expected.to have_one(:cadastral_qualification) }
    it { is_expected.to have_one(:basic_registration) }
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:age).to(:basic_registration) }
  end
end
