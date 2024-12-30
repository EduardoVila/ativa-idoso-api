# frozen_string_literal: true

require_relative '../../integrators/concerns/integrable'
require_relative '../../integrators/concerns/parseable'
require_relative 'webhook_trigger_command_error'

module API
  class WebhookTriggerCommand < ApplicationCommand
    include Integrable
    include Parseable

    attr_reader :webhook_event

    def initialize(webhook_event)
      super()
      @webhook_event = webhook_event
    end

    # Executes the webhook trigger command.
    #
    # This method performs the following steps:
    # 1. Checks if the webhook event has already been processed. If so, it returns immediately.
    # 2. Performs a POST request to trigger the webhook event.
    # 3. Raises an error if the response is not successful.
    # 4. Parses the response body.
    # 5. Updates the webhook event status to `processed` and stores the parsed response.
    # 6. Returns the updated webhook event.
    #
    # If a `Faraday::ConnectionFailed` or `API::WebhookTriggerCommandError` exception is raised,
    # it logs the error, updates the webhook event status to `error` with the error message,
    # and returns the updated webhook event.
    #
    # @return [WebhookEvent] the updated webhook event
    # @raise [API::WebhookTriggerCommandError] if the response from the POST request is not successful
    def call
      return if webhook_event.processed? # Guard clause to avoid unnecessary calls

      response = perform_post_request

      webhook_event.update(status: :processed, response: response.status)

      webhook_event
    rescue Faraday::Error => e
      ErrorLogger.log(e)

      webhook_event.update(status: :error, response: e)

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
      { webhook: webhook_event.payload }.to_json
    end

    def encoded_access_token_hash
      Base64.strict_encode64(webhook_event.access_token)
    end
  end
end
