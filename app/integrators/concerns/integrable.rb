# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'faraday/net_http'

module Integrable
  extend ActiveSupport::Concern

  def conn(proxy: nil)
    ::Faraday.new(ssl: ssl_options, proxy: proxy) do |f|
      f.request :url_encoded
      f.request(
        :retry,
        max: 9,
        interval: 0.1,
        interval_randomness: 0.5,
        backoff_factor: 2,
        exceptions: [Faraday::ConnectionFailed, Faraday::TimeoutError]
      )
      f.adapter :net_http
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
  end

  private

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
