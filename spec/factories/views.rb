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
FactoryBot.define do
  factory :view do
    percentage_watched { rand(0..100) }
    watched_completely { percentage_watched == 100 }

    user
    video
  end
end
