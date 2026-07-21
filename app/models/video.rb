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
class Video < ApplicationRecord
  has_many :views, dependent: :destroy

  enum :section, { upper_limbs: 0, lower_limbs: 1, hiking: 2 }
  enum :level, { beginner: 0, advanced: 2 }

  with_options presence: true do
    validates :title
    validates :url
  end
end
