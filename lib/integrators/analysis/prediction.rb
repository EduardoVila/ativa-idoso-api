# frozen_string_literal: true

require 'base64'

require_dependency 'errors/analysis/prediction_create_error'

module Integrators
  module Analysis
    class Prediction
      attr_reader :item

      include Formattable
      include Integrable
      include Parseable

      def initialize(item)
        @item = item
      end

      def post_request
        error_retries ||= 9

        response = do_request(:post, post[:url], post[:headers], post[:body])

        unless response.status == 200
          raise Errors::Analysis::PredictionCreateError
        end

        parsed_response_body = parser(response.body)

        prediction = initialize_object(parsed_response_body)
        prediction.item = item
        prediction.save
        prediction
      rescue Faraday::ConnectionFailed => e
        # ErrorLogger.log e

        unless error_retries.positive?
          raise Errors::Analysis::PredictionCreateError
        end

        error_retries -= 1

        sleep 3

        retry
      end

      private

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
            cpf: item.cpf,
            features: item.features
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
