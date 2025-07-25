# frozen_string_literal: true

FactoryBot.define do
  factory :api_webhook_credential, class: 'Api::WebhookCredential' do
    client_id { Faker::Number.number(digits: 10) }
    client_secret { Faker::Alphanumeric.alphanumeric(number: 20) }

    api_client factory: :api_client
  end
end
