# frozen_string_literal: true

namespace :db do
  desc 'Migrate api_webhook_events to use api_webhook_subscription association'
  task migrate_webhook_credentials: :environment do
    require_relative '../../config/environments' # Environment setup
    require_relative '../../config/application' # Application setup

    # client -> credentials -> subscriptions -> events
    Api::WebhookEvent.find_each do |event|
      api_client = event.api_client
      credentials = api_client.api_webhook_credentials
      next if credentials.empty?

      credentials.find_each do |credential|
        subscriptions = credential.api_wehbook_subscriptions
        next if subscriptions.empty?

        subscriptions.each do |subscription|
          subscription.api_webhook_events << event
        end
      end
    end
  end
end
