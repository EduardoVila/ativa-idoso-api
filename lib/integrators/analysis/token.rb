# frozen_string_literal: true

require 'base64'
require_relative '../../errors/analysis/token_post_response_error'
require_relative '../../concerns/nestable'
require_relative '../../concerns/integrable'
require_relative '../../concerns/parseable'
require_relative '../../error_logger'

module Integrators
  module Analysis
    class Token
      include Nestable
      include Integrable
      include Parseable

      # Create a new token for the analysis service using the client credentials
      # provided in the environment variables.
      def initialize
        @error_retries = 9
      end

      def post_request
        response = do_request(:post, post[:url], post[:headers], post[:body])

        unless response.status == 200
          raise ::Errors::Analysis::TokenPostResponseError
        end

        parsed_response_body = parser(response.body)

        token = initialize_object_with_nested_attributes(parsed_response_body)
        token.access_token = Base64.strict_decode64(token.access_token)

        token.save && token
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        unless @error_retries.positive?
          raise ::Errors::Analysis::TokenPostResponseError
        end

        @error_retries -= 1

        sleep 3

        retry
      end

      private

      # Endpoint: POST /api/v1/tokens
      def post
        {
          url: "#{ENV.fetch('PREDICTION_URL')}/api/v1/tokens",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.0',
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          body: URI.encode_www_form(
            'client_id' => Base64.strict_encode64(
              ENV.fetch('PREDICTION_CLIENT_ID')
            ),
            'client_secret' => Base64.strict_encode64(
              ENV.fetch('PREDICTION_CLIENT_SECRET')
            ),
            'grant_type' => 'client_credentials'
          )
        }
      end
    end
  end
end
