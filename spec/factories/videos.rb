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
FactoryBot.define do
  factory :video do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
  end
end
