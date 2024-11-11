# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_tokens
#
#  id           :uuid             not null, primary key
#  access_token :string
#  token_type   :string
#  expires_in   :integer
#  scope        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::Token, type: :model do
  describe 'factories' do
    subject { build :analysis_token }

    it { is_expected.to be_valid }
  end

  describe '#expired?' do
    context 'when created_at in older than the current date' do
      subject { create :analysis_token, :expired }

      it 'returns true' do
        expect(subject.expired?).to be(true)
      end
    end

    context 'when created_at is newer than the current date' do
      subject { create :analysis_token }

      it 'returns false' do
        expect(subject.expired?).to be(false)
      end
    end
  end
end
