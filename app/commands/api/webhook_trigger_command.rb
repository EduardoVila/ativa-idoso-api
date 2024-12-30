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

      raise API::WebhookTriggerCommandError unless response.success?

      parsed_response_body = parser(response.body)

      webhook_event.update(status: :processed, response: parsed_response_body)

      webhook_event
    rescue Faraday::ConnectionFailed,
           API::WebhookTriggerCommandError,
           StandardError => e
      ErrorLogger.log(e)

      webhook_event.update(status: :error, response: e.message)

      webhook_event
    end

    private

    # Sends a POST request to the specified webhook URL with the given payload and headers.
    #
    # @param webhook_event [Object] The event object containing the callback URL, access token, and payload.
    # @option webhook_event [String] :callback_url The URL to which the POST request will be sent.
    # @option webhook_event [String] :access_token The access token used for authorization, which will be encoded in Base64.
    # @option webhook_event [Hash] :payload The payload to be sent in the body of the POST request, which will be converted to JSON.
    #
    # @return [Faraday::Response] The response object from the HTTP request.
    def perform_post_request
      do_request(
        :post,
        webhook_event.callback_url,
        headers,
        webhook_event.payload.to_json
      )
    end

    # Generates a hash of HTTP headers for an API request.
    #
    # @param encoded_access_token_hash [String] The encoded access token to be included in the Authorization header.
    # @return [Hash] A hash containing the headers 'Content-Type', 'Accept', and 'Authorization'.
    #
    # Usage:
    # At client side, the encoded_access_token_hash must be strictly_decoded64,
    # and since it is a hashed token, it must be compared with the
    # hashed token in the client database to authenticate the request.
    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Strict-Transport-Security' => 'max-age=63072000; includeSubDomains; preload', # HSTS header
        'Authorization' => "Bearer #{encoded_access_token_hash}"
      }
    end

    def encoded_access_token_hash
      Base64.strict_encode64(webhook_event.access_token)
    end
  end
end
