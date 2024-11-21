# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_authentications
#
#  id            :uuid             not null, primary key
#  token_type    :string
#  refresh_token :string
#  access_token  :string
#  expires_in    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::Authentication, type: :model do
  describe 'factories' do
    subject { build :pro_score_authentication }

    it { is_expected.to be_valid }
  end

  describe 'custom methods' do
    describe '#expired?' do
      context 'when created_at in older than the current date' do
        subject { create :pro_score_authentication, :expired }

        it 'returns true' do
          expect(subject.expired?).to be(true)
        end
      end

      context 'when created_at is newer than the current date' do
        subject { create :pro_score_authentication }

        it 'returns false' do
          expect(subject.expired?).to be(false)
        end
      end
    end
  end
end
