# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProScore::Authentication, type: :model do
  context 'factories' do
    subject { build :pro_score_authentication }

    it { is_expected.to be_valid }
  end

  describe 'custom methods' do
    describe '#expired?' do
      context 'when created_at in older than the current date' do
        subject { create :pro_score_authentication, :expired }

        it 'returns true' do
          expect(subject.expired?).to eq(true)
        end
      end

      context 'when created_at is newer than the current date' do
        subject { create :pro_score_authentication }

        it 'returns false' do
          expect(subject.expired?).to eq(false)
        end
      end
    end
  end
end
