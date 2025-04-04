# frozen_string_literal: true

require_relative '../errors/guarantor/webhook_response_error'
require_relative '../application_integrator'

module Guarantor
  class WebhookIntegrator < ApplicationIntegrator
    def conn(proxy: nil)
      super.tap do |connection|
        connection.request(:authorization, :bearer, access_token)
      end
    end

    def create_resource(webhook_event)
      response = perform_post_request(webhook_event)

      raise API::WebhookTriggerCommandError unless response.success?

      webhook_event.tap do |w|
        w.update(status: :processed, response: response.status)
      end
    rescue Faraday::Error, ::Errors::Guarantor::WebhookPostResponseError => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request(webhook_event)
      do_request(
        :post, webhook_event.callback_url, headers, payload(webhook_event)
      )
    end

    def headers
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.12.2',
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

    def access_token
      ::Guarantor::TokenService.call.access_token
    end

    def enable_log_response
      true
    end

    def enable_log_request
      true
    end
  end
end
