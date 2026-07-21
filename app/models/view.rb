# frozen_string_literal: true

# == Schema Information
#
# Table name: views
#
#  id                 :bigint           not null, primary key
#  percentage_watched :integer          default(0)
#  watched_completely :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#  video_id           :bigint           not null
#
# Indexes
#
#  index_views_on_user_id   (user_id)
#  index_views_on_video_id  (video_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (video_id => videos.id)
#
class View < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :percentage_watched,
            numericality: {
              greater_than_or_equal_to: 0, less_than_or_equal_to: 100
            }
end
