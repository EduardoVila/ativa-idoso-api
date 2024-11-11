# frozen_string_literal: true

require 'base64'

require_relative '../../errors/analysis/token_create_error'
require_relative '../../concerns/formattable'
require_relative '../../concerns/integrable'
require_relative '../../concerns/parseable'
require_relative '../../error_logger'

module Integrators
  module Analysis
    class Token
      include Formattable
      include Integrable
      include Parseable

      # Create a new token for the analysis service using the client credentials
      # provided in the environment variables.
      # Endpoint: POST /api/v1/tokens
      def post_request
        error_retries ||= 9

        response = do_request(:post, post[:url], post[:headers], post[:body])

        raise Errors::Analysis::TokenCreateError unless response.status == 200

        parsed_response_body = parser(response.body)

        token = initialize_object(parsed_response_body)
        token.access_token = Base64.strict_decode64(token.access_token)
        token.save
        token
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        raise Errors::Analysis::TokenCreateError unless error_retries.positive?

        error_retries -= 1

        sleep 3

        retry
      end

      private

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
            'client_id' => client_credentials[:client_id64],
            'client_secret' => client_credentials[:client_secret64],
            'grant_type' => 'client_credentials'
          )
        }
      end

      def client_credentials
        {
          client_id64: Base64.strict_encode64(ENV.fetch('ANALYSIS_CLIENT_ID')),
          client_secret64: Base64.strict_encode64(
            ENV.fetch('ANALYSIS_CLIENT_SECRET')
          )
        }
      end
    end
  end
end
