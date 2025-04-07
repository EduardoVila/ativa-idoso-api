# frozen_string_literal: true

require 'base64'
require_relative '../errors/guarantor/token_response_error'
require_relative '../concerns/nestable'
require_relative '../concerns/integrable'
require_relative '../error_logger'

module Guarantor
  class TokenIntegrator < ApplicationIntegrator
    def create_resource
      response = perform_post_request

      raise ::Errors::Guarantor::TokenPostResponseError unless response.success?

      raw_data = response.body

      parsed_data = json_parse(raw_data)

      token = initialize_object_with_nested_attributes(parsed_data)

      token.tap(&:save)
    rescue Faraday::Error, ::Errors::Guarantor::TokenPostResponseError => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request
      do_request(:post, post_url, post_headers, post_body)
    end

    # Endpoint: POST /api/v2/authenticate
    def post_url
      ENV.fetch('GUARANTOR_TOKEN_URL')
    end

    def post_headers
      {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v2.12.2',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{Base64.strict_encode64(client_credentials)}"
      }
    end

    def post_body
      { grant_type: 'client_credentials' }
    end

    def client_credentials
      client_id = ENV.fetch('GUARANTOR_CLIENT_ID')
      client_secret = ENV.fetch('GUARANTOR_CLIENT_SECRET')
      "#{client_id}:#{client_secret}"
    end
  end
end
