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
require_relative 'application_serializer'

class ResearchSerializer < ApplicationSerializer
  attributes :id, :title, :questions

  def questions
    serialize_objects_collection(object.questions)
  end
end
