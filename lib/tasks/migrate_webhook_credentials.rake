# frozen_string_literal: true

namespace :db do
  desc 'Migrate webhook_events to use webhook_credential association'
  task migrate_webhook_credentials: :environment do
    require_relative '../../config/environments' # Environment setup
    require_relative '../../config/application' # Application setup

    Api::WebhookEvent.find_each do |event|
      credential = event.api_client.api_webhook_credentials.first
      next unless credential

      event.update!(api_webhook_credential: credential)
    end
  end
end
