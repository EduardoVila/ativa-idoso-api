# frozen_string_literal: true

module Api
  class WebhookCredential < ApplicationRecord
    encrypts :client_id, :client_secret, :auth_url

    belongs_to :api_client, class_name: 'Api::Client',
                            foreign_key: 'api_client_id'

    has_many :api_webhook_events, class_name: 'Api::WebhookEvent',
                                  foreign_key: 'api_webhook_credential_id',
                                  dependent: :destroy
  end
end
