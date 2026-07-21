# == Schema Information
#
# Table name: options
#
#  id            :bigint           not null, primary key
#  color         :string           not null
#  description   :string           not null
#  icon          :string           not null
#  other_options :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  question_id   :bigint           not null
#
# Indexes
#
#  index_options_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
FactoryBot.define do
  factory :option do
    color { Faker::Color.color_name }
    description { Faker::Lorem.sentence }
    icon { Faker::Lorem.word }
    other_options { [] }

    question
  end
end
