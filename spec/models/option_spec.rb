# frozen_string_literal: true

# == Schema Information
#
# Table name: options
#
#  id            :bigint           not null, primary key
#  color         :string           not null
#  description   :string           not null
#  icon          :string           not null
#  other_options :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  question_id   :bigint           not null
#
# Indexes
#
#  index_options_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
require 'spec_helper'

RSpec.describe Option, type: :model do
  describe 'factories' do
    subject { build :option }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :question }
    it { is_expected.to have_many :answers }
  end

  describe 'validations' do
    describe 'color' do
      it { is_expected.to validate_presence_of :color }
    end

    describe 'description' do
      it { is_expected.to validate_presence_of :description }
    end

    describe 'icon' do
      it { is_expected.to validate_presence_of :icon }
    end
  end
end
