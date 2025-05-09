# frozen_string_literal: true

require 'base64'
require_relative '../errors/serasa/response_error'

module Serasa
  class AuthenticationIntegrator < ApplicationIntegrator
    def conn(proxy: nil)
      super.tap do |connection|
        connection.request(
          :authorization, :basic, client_credentials
        )
      end
    end

    def authenticate
      response = perform_post_request

      raise ::Errors::Serasa::ResponseError unless response.success?

      body = json_parse(response.body)

      serasa_authentication = initialize_object_with_nested_attributes(body)

      serasa_authentication.save && serasa_authentication
    rescue Faraday::ConnectionFailed, Faraday::Error => e
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
      EnvHelper.fetch('SERASA_FINTECH_REPORT_LOGIN_URL')
    end

    def client_credentials
      username = Base64.strict_encode64(
        EnvHelper.fetch('SERASA_FINTECH_REPORT_USERNAME')
      )
      password = Base64.strict_encode64(
        EnvHelper.fetch('SERASA_FINTECH_REPORT_PASSWORD')
      )

      "#{username}:#{password}"
    end
  end
end
