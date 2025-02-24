# frozen_string_literal: true

require 'base64'
require_relative '../errors/analysis/token_response_error'
require_relative '../concerns/nestable'
require_relative '../concerns/integrable'
require_relative '../error_logger'

module Analysis
  class TokenIntegrator < ApplicationIntegrator
    def create_resource
      response = perform_post_request

      raise ::Errors::Analysis::TokenPostResponseError unless response.success?

      raw_data = response.body

      parsed_data = json_parse(raw_data)

      token = initialize_object_with_nested_attributes(parsed_data)

      token.save && token
    rescue Faraday::Error, ::Errors::Analysis::TokenPostResponseError => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request
      do_request(:post, post_url, post_headers, post_body)
    end

    # Endpoint: POST /api/v1/tokens
    def post_url
      ENV.fetch('PREDICTION_TOKEN_URL')
    end

    def post_headers
      {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v2.12.2',
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    end

    def post_body
      {
        client_id: Base64.strict_encode64(ENV.fetch('PREDICTION_CLIENT_ID')),
        client_secret: Base64.strict_encode64(
          ENV.fetch('PREDICTION_CLIENT_SECRET')
        ),
        grant_type: 'client_credentials'
      }
    end
  end
end
