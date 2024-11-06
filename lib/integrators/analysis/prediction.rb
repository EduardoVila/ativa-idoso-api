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

      def create_resource(analysis_item)
        response = perform_post_request(analysis_item)

        unless response.success?
          raise ::Errors::Analysis::PredictionPostResponseError
        end

        parsed_response_body = parser(response.body)
        prediction = build_prediction(parsed_response_body, analysis_item)

        prediction.save && prediction
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e
        raise ::Errors::Analysis::PredictionPostResponseError
      end

      private

      def perform_post_request(analysis_item)
        do_request(:post, post_url, post_headers, post_body(analysis_item))
      end

      def build_prediction(parsed_response_body, analysis_item)
        prediction = initialize_object_with_nested_attributes(
          parsed_response_body
        )
        prediction.item = analysis_item
        prediction
      end

      # Endpoint: POST /api/v1/predictions
      def post_url
        "#{ENV.fetch('PREDICTION_URL')}/api/v1/predictions"
      end

      def post_headers
        {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Faraday v2.12.0',
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{access_token64}"
        }
      end

      def post_body(analysis_item)
        {
          cpf: analysis_item.cpf,
          features: analysis_item.features
        }.to_json
      end

      def access_token64
        token = ::Analysis::TokenService.call

        Base64.strict_encode64(token.access_token)
      end
    end
  end
end
