# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'faraday/net_http'

module Integrable
  extend ActiveSupport::Concern

  def conn(proxy: nil)
    ::Faraday.new(ssl: ssl_options, proxy: proxy) do |f|
      f.request(:url_encoded) # Encode request params as "application/x-www-form-urlencoded"
      f.request(:retry, retry_options) # Retry requests on failure
      f.adapter(:net_http) # Use the Net::HTTP adapter
      f.response(:raise_error) # Raise exceptions on 4xx and 5xx responses
    end
  end

  def do_request(verb, url, headers, params = nil, proxy = nil)
    connection = conn(proxy: proxy)
    response = connection.public_send(verb) do |req|
      req.url url
      req.headers.update(headers) if headers
      req.headers['Idempotency-Key'] = SecureRandom.uuid if verb == :post # ensure idempotency on POST requests

      req.body = params if params

      RequestLogger.log(req) if enable_log_request
    end

    ResponseLogger.log(response, 'integrable', params) if enable_log_response

    response
  rescue Faraday::Error => e # Rescue Faraday errors and log them
    ErrorLogger.log(e)

    raise e
  end

  private

  def retry_options
    {
      max: 9,
      interval: 0.1,
      interval_randomness: 0.5,
      backoff_factor: 2,
      methods: %i[get post put delete],
      retry_if: ->(env, _exc) { env.body[:success] == 'false' }, # retry if response is not successful
      exceptions: retry_exceptions
    }
  end

  def retry_exceptions
    if ENV.fetch('RACK_ENV') == 'test'
      return Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS
    end

    Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::ConnectionFailed]
  end

  def enable_log_response
    false
  end

  def enable_log_request
    false
  end

  def use_certificate
    false
  end

  def ssl_options
    return {} unless use_certificate

    {
      client_cert: OpenSSL::X509::Certificate.new(ca_certificate),
      client_key: OpenSSL::PKey::RSA.new(ca_key)
    }
  end

  def ca_certificate
    raise NotImplementedError
  end

  def ca_key
    raise NotImplementedError
  end
end
