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
FactoryBot.define do
  factory :question do
    description { Faker::Lorem.sentence }

    research
  end
end
