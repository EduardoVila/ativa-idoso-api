# frozen_string_literal: true

require 'base64'

require_dependency 'errors/analysis/token_create_error'

module Integrators
  module Analysis
    class Token
      include Formattable
      include Integrable
      include Parseable

      def create
        error_retries ||= 9

        response = do_request(:post, post[:url], post[:headers], post[:body])

        raise Errors::Analysis::TokenCreateError unless response.status == 200

        parsed_response_body = parser(response.body)

        create_object(parsed_response_body)
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        raise create_error unless error_retries.positive?

        error_retries -= 1

        sleep 3

        retry
      end

      private

      def post
        {
          url: 'http://localhost:8000/api/v1/tokens',
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
