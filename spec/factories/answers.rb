# == Schema Information
#
# Table name: answers
#
#  id         :bigint           not null, primary key
#  complement :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  option_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_answers_on_option_id  (option_id)
#  index_answers_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :answer do
    complement { Faker::Lorem.sentence }

    option
    user
  end
end
