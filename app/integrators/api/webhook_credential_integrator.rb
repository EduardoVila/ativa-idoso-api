# frozen_string_literal: true

module Api
  class WebhookCredentialIntegrator < ApplicationIntegrator
    DEFAULT_TOKEN_TTL = 3600

    def create_resource(webhook_credential)
      return unless webhook_credential

      response = perform_post_request(webhook_credential)

      raw_data = response.body

      parsed = JSON.parse(raw_data).with_indifferent_access

      {
        access_token: parsed[:access_token],
        expires_in: parsed[:expires_in] || DEFAULT_TOKEN_TTL,
        expires_at: Time.now.to_i + (parsed[:expires_in] || DEFAULT_TOKEN_TTL)
      }
    rescue Faraday::Error => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request(webhook_credential)
      do_request(
        :post, webhook_credential.auth_url, headers(webhook_credential), body
      )
    end

    def headers(webhook_credential)
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.13.1',
        content_type: 'application/x-www-form-urlencoded',
        authorization: "Basic #{enc64(webhook_credential)}"
      }
    end

    def enc64(webhook_credential)
      Base64.strict_encode64(
        "#{webhook_credential.client_id}:#{webhook_credential.client_secret}"
      )
    end

    def body
      { grant_type: 'client_credentials' }
    end
  end
end
