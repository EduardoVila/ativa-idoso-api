# frozen_string_literal: true

module Api
  class WebhookSubscription < ApplicationRecord
    belongs_to :api_webhook_credential, class_name: 'Api::WebhookCredential',
                                        foreign_key: 'api_webhook_credential_id'

    has_many :api_webhook_events, class_name: 'Api::WebhookEvent',
                                  foreign_key: 'api_webhook_subscription_id',
                                  inverse_of: :api_webhook_subscription,
                                  dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validates :endpoint_url, presence: true,
                             format: { with: URI::DEFAULT_PARSER.make_regexp }

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :by_type, ->(type) { where(type: type) }
  end
end
