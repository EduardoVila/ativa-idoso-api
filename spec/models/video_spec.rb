# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id         :bigint           not null, primary key
#  level      :integer          not null
#  section    :integer          not null
#  title      :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'spec_helper'

RSpec.describe Video, type: :model do
  describe 'factories' do
    subject { build :video }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_many :views }
  end

  describe 'validations' do
    describe 'title' do
      it { is_expected.to validate_presence_of :title }
    end

    describe 'url' do
      it { is_expected.to validate_presence_of :url }
    end
  end
end
