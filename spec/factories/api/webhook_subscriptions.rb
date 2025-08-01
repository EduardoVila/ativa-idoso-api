# frozen_string_literal: true

FactoryBot.define do
  factory :api_webhook_subscription, class: 'Api::WebhookSubscription' do
    name { Faker::Lorem.word }
    endpoint_url { Faker::Internet.url }

    api_webhook_credential

    trait :with_api_webhook_events do
      after(:create) do |subscription|
        create_list(
          :api_webhook_event, 2, api_webhook_subscription: subscription
        )
      end
    end
  end
end
