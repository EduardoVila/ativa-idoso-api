# frozen_string_literal: true

require_relative '../errors/api/webhook_response_error'
require_relative '../application_integrator'

module Api
  class WebhookIntegrator < ApplicationIntegrator
    def create_resource(webhook_event)
      response = perform_post_request(webhook_event)

      raise Api::WebhookTriggerCommandError unless response.success?

      webhook_event.tap do |w|
        w.update(status: :processed, response: response.status)
      end
    rescue Faraday::Error, ::Errors::Api::WebhookPostResponseError => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request(webhook_event)
      do_request(
        :post,
        webhook_event.callback_url,
        headers(webhook_event.requester),
        payload(webhook_event)
      )
    end

    def headers(requester)
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.12.2',
        content_type: 'application/json',
        authorization: "Bearer #{access_token(requester)}"
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

    def access_token(requester)
      case requester
      when 'analyzes'
        ::Analyzes::TokenService.call.access_token
      when 'guarantor'
        ::Guarantor::TokenService.call.access_token
      else
        raise ::Errors::Api::WebhookTriggerCommandError
      end
    end

    def enable_log_response
      true
    end

    def enable_log_request
      true
    end
  end
end
