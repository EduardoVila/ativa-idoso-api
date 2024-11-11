# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_tokens
#
#  id           :uuid             not null, primary key
#  access_token :string
#  token_type   :string
#  expires_in   :integer
#  scope        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :analysis_token, class: 'Analysis::Token' do
    access_token { Faker::Alphanumeric.alphanumeric(number: 32) }
    token_type { 'Bearer' }
    expires_in { 300 }

    trait :expired do
      created_at { Time.zone.now - 500 }
    end
  end
end
