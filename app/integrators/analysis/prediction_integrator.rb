# frozen_string_literal: true

require 'base64'
require_relative '../errors/analysis/prediction_post_response_error'
require_relative '../application_integrator'

module Analysis
  class PredictionIntegrator < ApplicationIntegrator
    def conn(proxy: nil)
      super(proxy: proxy).tap do |connection|
        connection.request(:authorization, :bearer, access_token)
      end
    end

    def create_resource(analysis_item)
      response = perform_post_request(analysis_item)

      unless response.success?
        raise ::Errors::Analysis::PredictionPostResponseError
      end

      parsed_response_body = json_parse(response.body)

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
      ENV.fetch('PREDICTION_URL')
    end

    def post_headers
      {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v2.12.2',
        'Content-Type' => 'application/json'
      }
    end

    def post_body(analysis_item)
      {
        cpf: analysis_item.cpf,
        features: analysis_item.featurable
      }.to_json
    end

    def access_token
      token = ::Analysis::TokenService.call

      Base64.strict_encode64(token.access_token)
    end
  end
end
