# frozen_string_literal: true

require_relative '../../integrators/concerns/integrable'
require_relative 'webhook_trigger_command_error'

module API
  class WebhookTriggerCommand < ApplicationCommand
    include Integrable

    attr_reader :webhook_event

    def initialize(webhook_event)
      super()
      @webhook_event = webhook_event
    end

    def call
      return if webhook_event.processed? # Guard clause to avoid unnecessary calls

      response = perform_post_request

      webhook_event.update(status: :processed, response: response.status)

      webhook_event
    rescue Faraday::Error => e
      ErrorLogger.log(e)

      webhook_event.update(status: :error, response: e.message)

      Analysis::Report.find(webhook_event.event_id).update(status: :error)

      webhook_event
    end

    private

    def perform_post_request
      do_request(:post, url, headers, payload)
    end

    def url
      webhook_event.callback_url
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Strict-Transport-Security' => 'max-age=63072000; includeSubDomains; preload', # HSTS header
        'Authorization' => "Bearer #{encoded_access_token_hash}"
      }
    end

    def payload
      {
        data: {
          webhook_payload: webhook_event.payload,
          callback_id: webhook_event.callback_id
        }
      }.to_json
    end

    def encoded_access_token_hash
      Base64.strict_encode64(webhook_event.access_token)
    end

    def enable_log_response
      true
    end

    def enable_log_request
      true
    end
  end
end
