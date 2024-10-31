# frozen_string_literal: true

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
