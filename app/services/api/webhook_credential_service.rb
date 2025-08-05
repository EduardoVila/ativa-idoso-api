# frozen_string_literal: true

module Api
  class WebhookCredentialService < ApplicationService
    DEFAULT_TOKEN_TTL = 28_800 # Default TTL of 8 hours

    def initialize(integrator = Api::WebhookCredentialIntegrator)
      @integrator = integrator
    end

    def call(webhook_credential)
      return unless webhook_credential

      cache_key = cache_key_for(webhook_credential)

      cached = RedisCache.get(cache_key)

      return cached[:access_token] if cached && !expired?(cached)

      token_data = request_token(webhook_credential)

      RedisCache.set(
        cache_key,
        token_data,
        ttl: token_data[:expires_in] || DEFAULT_TOKEN_TTL
      )

      token_data[:access_token]
    end

    private

    def cache_key_for(webhook_credential)
      "webhook_token:#{webhook_credential.id}"
    end

    def expired?(cached)
      return true unless cached[:expires_at]

      Time.now.to_i >= cached[:expires_at]
    end

    def request_token(webhook_credential)
      @integrator.new.create_resource(webhook_credential)
    end
  end
end
