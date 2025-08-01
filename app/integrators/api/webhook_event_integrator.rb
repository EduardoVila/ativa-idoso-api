# frozen_string_literal: true

require_relative '../errors/api/webhook_response_error'
require_relative '../application_integrator'

module Api
  class WebhookEventIntegrator < ApplicationIntegrator
    def initialize(service = Api::WebhookCredentialService)
      @service = service
      super()
    end

    def create_resource(webhook_event, webhook_subscription)
      return if webhook_event.blank? || webhook_subscription.blank?

      response = perform_post_request(webhook_event, webhook_subscription)

      raise ::Errors::Api::WebhookPostResponseError unless response.success?

      webhook_event.tap do |w|
        w.update(status: :processed, response: response.status)
      end
    rescue Faraday::Error, ::Errors::Api::WebhookPostResponseError => e
      webhook_event.tap do |w|
        w.update(status: :error, response: e.message)
      end

      error_message(webhook_event, e).tap do |msg|
        Logger.new($stdout).error(msg)

        Sidekiq.logger.error(msg)
      end

      ErrorLogger.log e # Sentry logging to monitor webhook delivery issues

      raise e # Bubble up the error to be handled by Sidekiq retries
    end

    private

    def perform_post_request(webhook_event, webhook_subscription)
      do_request(
        :post,
        webhook_subscription.endpoint_url,
        headers.merge(authorization_header(webhook_subscription)),
        payload(webhook_event)
      )
    end

    def headers
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.13.1',
        content_type: 'application/json'
      }
    end

    def payload(webhook_event)
      {
        data: {
          webhook_payload: webhook_event.payload,
          callback_id: webhook_event.callback_id
        }
      }.to_json
    end

    def authorization_header(webhook_subscription)
      credential = webhook_subscription.api_webhook_credential
      return unless credential

      access_token = access_token(credential)
      return unless access_token

      { authorization: "Bearer #{access_token}" }
    end

    def access_token(webhook_credential)
      @service.new.call(webhook_credential)
    end

    def enable_log_response?
      true
    end

    def enable_log_request?
      true
    end

    def error_message(webhook_event, err)
      <<~FAIL
        Webhook delivery failed.

        Object: webhook_event_id: #{webhook_event.id}
        Destination: #{webhook_event.callback_url}
        Exception: #{err}
      FAIL
    end
  end
end
