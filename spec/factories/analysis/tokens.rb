# frozen_string_literal: true

FactoryBot.define do
  factory :analysis_token, class: 'Analysis::Token' do
    access_token { Faker::Alphanumeric.alphanumeric(number: 32) }
    token_type { 'Bearer' }
    expires_in { 300 }

    trait :expired do
      created_at { Time.now - 500 }
    end
  end
end
