# frozen_string_literal: true

require 'base64'
require_relative '../concerns/nestable'
require_relative '../concerns/integrable'
require_relative '../concerns/parseable'
require_relative '../errors/serasa/response_error'

module Serasa
  class AuthenticationIntegrator
    include Parseable
    include Integrable
    include Nestable

    def conn(proxy: nil)
      super(proxy: proxy).tap do |connection|
        connection.request(
          :authorization, :basic, client_credentials
        )
      end
    end

    def authenticate
      response = perform_post_request

      raise ::Errors::Serasa::ResponseError unless response.success?

      body = parser(response.body)

      serasa_authentication = initialize_object_with_nested_attributes(body)

      serasa_authentication.save && serasa_authentication
    rescue Faraday::ConnectionFailed => e
      ErrorLogger.log e
      raise ::Errors::Serasa::ResponseError
    end

    private

    def perform_post_request
      do_request(:post, post_url, headers, post_body)
    end

    def post_body
      {}.to_json
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def post_url
      ENV.fetch('SERASA_FINTECH_REPORT_LOGIN_URL')
    end

    def client_credentials
      username = Base64.strict_encode64(
        ENV.fetch('SERASA_FINTECH_REPORT_USERNAME')
      )
      password = Base64.strict_encode64(
        ENV.fetch('SERASA_FINTECH_REPORT_PASSWORD')
      )

      "#{username}:#{password}"
    end
  end
end
