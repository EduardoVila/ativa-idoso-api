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
require_relative 'application_serializer'

class VideoSerializer < ApplicationSerializer
  attributes :id, :level, :title, :url
end
