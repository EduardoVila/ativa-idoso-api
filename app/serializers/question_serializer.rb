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
require_relative 'application_serializer'

class QuestionSerializer < ApplicationSerializer
  attributes :id, :description, :options

  def options
    serialize_objects_collection(object.options)
  end
end
