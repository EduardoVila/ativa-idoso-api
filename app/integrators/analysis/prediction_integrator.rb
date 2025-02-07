# frozen_string_literal: true

require_relative '../errors/analysis/prediction_response_error'
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
      raw_data = response.body
      parsed_data = json_parse(raw_data)

      prediction = build_prediction(parsed_data, analysis_item, raw_data)

      prediction.save && prediction
    rescue Faraday::ConnectionFailed => e
      ErrorLogger.log e
      raise ::Errors::Analysis::PredictionPostResponseError
    end

    def show_resource(id)
      response = perform_get_request(id)
      raw_data = response.body
      parsed_response_body = json_parse(raw_data)

      build_prediction(parsed_response_body, nil, response.body)
    rescue Faraday::Error => e
      ErrorLogger.log e
      raise ::Errors::Analysis::PredictionGetResponseError
    end

    private

    def perform_get_request(id)
      do_request(:get, get_url(id), headers)
    end

    def perform_post_request(analysis_item)
      do_request(:post, post_url, headers, post_body(analysis_item))
    end

    def build_prediction(parsed_data, analysis_item, raw_data)
      prediction = initialize_object_with_nested_attributes(parsed_data)
      prediction.item = analysis_item
      prediction.raw_data = raw_data

      prediction
    end

    # Endpoint: POST /api/v1/predictions
    def post_url
      ENV.fetch('PREDICTION_URL')
    end

    def get_url(id)
      "#{ENV.fetch('PREDICTION_URL')}/#{id}"
    end

    def headers
      {
        accept: '*/*',
        accept_encoding: 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        user_agent: 'Faraday v2.12.2',
        content_type: 'application/json'
      }
    end

    def post_body(analysis_item)
      {
        cpf: analysis_item.cpf,
        features: analysis_item.featurable
      }.to_json
    end

    def access_token
      ::Analysis::TokenService.call.access_token
    end
  end
end
