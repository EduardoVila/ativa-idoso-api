# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_authentications
#
#  id           :uuid             not null, primary key
#  access_token :string
#  expires_in   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Authentication, type: :model do
  describe 'factories' do
    subject { build :serasa_authentication }

    it { is_expected.to be_valid }
  end

  describe 'custom methods' do
    describe '#expired?' do
      context 'when expires_in in older than the current date' do
        subject { create :serasa_authentication, :expired }

        it 'returns true' do
          expect(subject.expired?).to be(true)
        end
      end

      context 'when expires_in is newer than the current date' do
        subject { create :serasa_authentication }

        it 'returns false' do
          expect(subject.expired?).to be(false)
        end
      end
    end
  end
end
