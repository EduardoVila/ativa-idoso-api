# frozen_string_literal: true

require 'base64'
require_relative '../errors/analysis/token_post_response_error'
require_relative '../concerns/nestable'
require_relative '../concerns/integrable'
require_relative '../concerns/parseable'
require_relative '../error_logger'

module Analysis
  class TokenIntegrator < ApplicationIntegrator

    def create_resource
      response = perform_post_request

      raise ::Errors::Analysis::TokenPostResponseError unless response.success?

      parsed_response_body = parser(response.body)

      token = initialize_object_with_nested_attributes(parsed_response_body)
      token.access_token = Base64.strict_decode64(token.access_token)

      token.save && token
    rescue Faraday::ConnectionFailed => e
      ErrorLogger.log e
      raise ::Errors::Analysis::TokenPostResponseError
    end

    private

    def perform_post_request
      do_request(:post, post_url, post_headers, post_body)
    end

    # Endpoint: POST /api/v1/tokens
    def post_url
      "#{ENV.fetch('PREDICTION_URL')}/api/v1/tokens"
    end

    def post_headers
      {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v2.12.0',
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    end

    def post_body
      URI.encode_www_form(
        'client_id' => Base64.strict_encode64(
          ENV.fetch('PREDICTION_CLIENT_ID')
        ),
        'client_secret' => Base64.strict_encode64(
          ENV.fetch('PREDICTION_CLIENT_SECRET')
        ),
        'grant_type' => 'client_credentials'
      )
    end
  end
end
