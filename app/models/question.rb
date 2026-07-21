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
class Question < ApplicationRecord
  belongs_to :research

  has_many :options, dependent: :destroy

  validates :description, presence: true
end
