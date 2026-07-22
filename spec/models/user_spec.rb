# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  access_token :string
#  cpf          :string           not null
#  name         :string           not null
#  status       :integer          default("research_pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_cpf  (cpf) UNIQUE
#
require 'spec_helper'

RSpec.describe User, type: :model do
  describe 'factories' do
    subject { build :user }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_many :answers }
    it { is_expected.to have_many :views }
    it { is_expected.to have_one :satisfaction_survey_response }
  end

  describe 'validations' do
    describe 'cpf' do
      it { is_expected.to validate_cpf_for :cpf }
      it { is_expected.to validate_presence_of :cpf }
    end

    describe 'name' do
      it { is_expected.to validate_presence_of :name }
    end
  end

  describe 'enums' do
    it {
      expect(subject).to(
        define_enum_for(:status).with_values(
          research_pending: 0, active: 1
        )
      )
    }
  end
end
