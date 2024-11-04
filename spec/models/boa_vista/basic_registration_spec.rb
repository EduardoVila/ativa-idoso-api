# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_basic_registrations
#
#  id                     :uuid             not null, primary key
#  cpf                    :string
#  name                   :string
#  mother_name            :string
#  birth_date             :string
#  exposed_person         :string
#  cpf_situation          :string
#  boa_vista_cadastral_id :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::BasicRegistration, type: :model do
  describe 'factories' do
    subject { build :boa_vista_basic_registration }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral) }
  end

  describe '.age' do
    context 'when the birth date has a valid date' do
      subject do
        create :boa_vista_basic_registration, birth_date: Time.now
      end

      it 'returns the age correctly' do
        expect(subject.age).to eq(0)
      end
    end

    context 'when the birth date is empty' do
      subject { create :boa_vista_basic_registration, birth_date: nil }

      it 'returns nil' do
        expect(subject.age).to be_nil
      end
    end

    context 'when the birth date is not a valid date' do
      subject { create :boa_vista_basic_registration, birth_date: '-' }

      it 'returns nil' do
        expect(subject.age).to be_nil
      end
    end
  end
end
