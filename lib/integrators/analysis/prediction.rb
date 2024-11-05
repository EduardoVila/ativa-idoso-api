# frozen_string_literal: true

require 'base64'
require_relative '../../errors/analysis/prediction_post_response_error'
require_relative '../../concerns/nestable'
require_relative '../../concerns/integrable'
require_relative '../../concerns/parseable'
require_relative '../../error_logger'

module Integrators
  module Analysis
    class Prediction
      include Nestable
      include Integrable
      include Parseable

      def post_request(analysis_item)
        @analysis_item = analysis_item

        error_retries ||= 9

        response = do_request(:post, post[:url], post[:headers], post[:body])

        unless response.status == 200
          raise ::Errors::Analysis::PredictionPostResponseError
        end

        parsed_response_body = parser(response.body)

        prediction = initialize_object_with_nested_attributes(
          parsed_response_body
        )
        prediction.item = analysis_item

        prediction.save && prediction
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        unless error_retries.positive?
          raise ::Errors::Analysis::PredictionPostResponseError
        end

        error_retries -= 1

        sleep 3

        retry
      end

      private

      # Endpoint: POST /api/v1/predictions
      def post
        {
          url: "#{ENV.fetch('PREDICTION_URL')}/api/v1/predictions",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.0',
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{access_token64}"
          },
          body: {
            cpf: @analysis_item.cpf,
            features: @analysis_item.features
          }.to_json
        }
      end

      def access_token64
        token = ::Analysis::TokenService.call

        Base64.strict_encode64(token.access_token)
      end
    end
  end
end
