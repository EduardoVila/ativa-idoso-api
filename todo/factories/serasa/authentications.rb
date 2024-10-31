# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_authentication, class: 'Serasa::Authentication' do
    access_token { Faker::Internet.device_token }
    expires_in { (Time.zone.now + 60.minutes).to_time.to_i }

    trait :expired do
      expires_in { (Time.zone.now - 60.minutes).to_time.to_i }
    end
  end
end
