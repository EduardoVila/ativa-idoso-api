# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastrals
#
#  id            :bigint           not null, primary key
#  consumer_type :string           not null
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  consumer_id   :uuid             not null
#
# Indexes
#
#  index_boa_vista_cadastrals_on_consumer  (consumer_type,consumer_id) UNIQUE
#
require 'spec_helper'

RSpec.describe BoaVista::Cadastral, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    subject { create :boa_vista_cadastral }

    it {
      expect(subject).to validate_uniqueness_of(:consumer_id)
        .scoped_to(:consumer_type)
        .ignoring_case_sensitivity
    }
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
