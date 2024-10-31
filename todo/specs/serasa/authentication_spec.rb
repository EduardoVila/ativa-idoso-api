# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::Authentication, type: :model do
  context 'factories' do
    subject { build :serasa_authentication }

    it { is_expected.to be_valid }
  end

  describe 'custom methods' do
    describe '#expired?' do
      context 'when expires_in in older than the current date' do
        subject { create :serasa_authentication, :expired }

        it 'returns true' do
          expect(subject.expired?).to eq(true)
        end
      end

      context 'when expires_in is newer than the current date' do
        subject { create :serasa_authentication }

        it 'returns false' do
          expect(subject.expired?).to eq(false)
        end
      end
    end
  end
end
