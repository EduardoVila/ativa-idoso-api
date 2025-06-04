# frozen_string_literal: true

require 'base64'
require_relative '../concerns/nestable'
require_relative '../concerns/integrable'
require_relative '../error_logger'

module Analyzes
  class TokenIntegrator < ApplicationIntegrator
    def create_resource
      response = perform_post_request

      raise Faraday::Error unless response.success?

      raw_data = response.body

      parsed_data = json_parse(raw_data)

      token = initialize_object_with_nested_attributes(parsed_data)

      token.tap(&:save)
    rescue Faraday::Error => e
      ErrorLogger.log e

      raise e
    end

    private

    def perform_post_request
      do_request(:post, post_url, post_headers, post_body)
    end

    # Endpoint: POST /api/v1/tokens
    def post_url
      EnvHelper.fetch('ANALYZES_TOKEN_URL')
    end

    def post_headers
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.13.1',
        content_type: 'application/x-www-form-urlencoded',
        authorization: "Basic #{Base64.strict_encode64(client_credentials)}"
      }
    end

    def post_body
      { grant_type: 'client_credentials' }
    end

    def client_credentials
      client_id = EnvHelper.fetch('ANALYZES_CLIENT_ID')
      client_secret = EnvHelper.fetch('ANALYZES_CLIENT_SECRET')
      "#{client_id}:#{client_secret}"
    end
  end
end
