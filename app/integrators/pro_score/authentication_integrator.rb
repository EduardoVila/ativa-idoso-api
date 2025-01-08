# frozen_string_literal: true

module ProScore
  class AuthenticationIntegrator < ApplicationIntegrator
    def authenticate
      response = perform_post_request

      raise ::Errors::ProScore::ResponseError unless response.success?

      body = json_parse(response.body)

      pro_score_authentication = initialize_object_with_nested_attributes(body)

      pro_score_authentication.save && pro_score_authentication
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      ErrorLogger.log e
      raise ::Errors::ProScore::ResponseError
    end

    private

    def perform_post_request
      do_request(:post, request_url, headers, request_body)
    end

    def request_body
      {
        grant_type: 'password',
        client_id: 2,
        client_secret: credentials[:client_secret],
        username: credentials[:username],
        password: credentials[:password],
        scope: '*'
      }.to_json
    end

    def credentials
      {
        client_secret: ENV.fetch('PRO_SCORE_CLIENT_SECRET'),
        username: ENV.fetch('PRO_SCORE_USERNAME'),
        password: ENV.fetch('PRO_SCORE_PASSWORD')
      }
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def request_url
      'https://api.proscore.com.br/oauth/token'
    end
  end
end
