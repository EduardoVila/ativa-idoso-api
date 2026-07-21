# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  research_id :bigint           not null
#
# Indexes
#
#  index_questions_on_research_id  (research_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_id => researches.id)
#
require 'spec_helper'

RSpec.describe Question, type: :model do
  describe 'factories' do
    subject { build :question }

    it { expect(subject).to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :research }
    it { is_expected.to have_many :options }
  end

  describe 'validations' do
    describe 'description' do
      it { is_expected.to validate_presence_of :description }
    end
  end
end
