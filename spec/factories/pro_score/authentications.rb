# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_authentications
#
#  id            :bigint           not null, primary key
#  token_type    :string
#  refresh_token :string
#  access_token  :string
#  expires_in    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :pro_score_authentication, class: 'ProScore::Authentication' do
    token_type { 'Bearer' }
    expires_in { '86400' }
    access_token { Faker::Alphanumeric.alphanumeric(number: 983) }
    refresh_token { Faker::Alphanumeric.alphanumeric(number: 712) }

    trait :expired do
      created_at { Time.zone.now - 2.days }
    end
  end
end
