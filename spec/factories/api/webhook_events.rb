# frozen_string_literal: true

FactoryBot.define do
  factory :api_webhook_event, class: 'API::WebhookEvent' do
    event_id { SecureRandom.uuid }
    status { 'received' }

    client factory: :api_client
  end
end
