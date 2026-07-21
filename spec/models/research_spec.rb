# frozen_string_literal: true

# == Schema Information
#
# Table name: researches
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'spec_helper'

RSpec.describe Research, type: :model do
  describe 'factories' do
    subject { build :research }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_many :questions }
  end

  describe 'validations' do
    describe 'title' do
      it { is_expected.to validate_presence_of :title }
    end
  end
end
