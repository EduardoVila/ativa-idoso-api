# frozen_string_literal: true

require 'faraday'
require 'faraday/net_http'
require 'logger'

module Integrable
  extend ActiveSupport::Concern

  MAX_RETRIES = 9
  RETRY_WAIT = 1

  def conn(proxy: nil)
    ::Faraday.new(ssl: ssl_options, proxy: proxy) do |f|
      # Encode request params as "application/x-www-form-urlencoded"
      f.request(:url_encoded)

      # Use the Net::HTTP adapter
      f.adapter(:net_http)

      # Raise exceptions on 4xx and 5xx responses
      f.response(:raise_error)
    end
  end

  def do_request(verb, url, headers, params = nil, proxy = nil) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    retries = 0
    begin
      connection = conn(proxy: proxy)

      response = connection.public_send(verb) do |req|
        req.url url
        req.headers.update(headers) if headers
        req.body = params if params
        req.headers['X-Idempotency-Key'] = SecureRandom.uuid if verb == :post

        RequestLogger.log(req) if enable_log_request?
      end

      ResponseLogger.log(response, 'integrable', params) if enable_log_response?

      response
    rescue Faraday::Error => e
      retries += 1

      if should_retry?(e, url, verb) && retries <= MAX_RETRIES
        logger = Logger.new($stdout)
        logger.info(
          <<~LOG
            Retrying Faraday request (attempt #{retries} of #{MAX_RETRIES});
            Sleeping #{calculate_jittered_exponential_backoff(retries)} seconds
            Exception: #{e}
          LOG
        )

        sleep calculate_jittered_exponential_backoff(retries)
        retry
      end

      ErrorLogger.log(e)

      raise e
    end
  end

  private

  def should_retry?(exception, _url = nil, _verb = nil)
    return false if AlpopAnalysis.test?

    # Comment out if idempotency logic is breaking:
    # return false if url.include?('alpop.com.br') && verb == :post

    [
      Faraday::ConnectionFailed,
      Faraday::TimeoutError,
      Faraday::ServerError
    ].any? { |error| exception.is_a?(error) }
  end

  def calculate_jittered_exponential_backoff(retry_count)
    # Exponential backoff with decorrelated jitter: min(1s * 2^(retry_count - 1), 30s) * rand(0.5..1.5)
    base_wait = RETRY_WAIT * (2**(retry_count - 1)) # Exponential backoff
    max_wait = 30 # Hard ceiling for wait time to prevent waiting too long
    [base_wait, max_wait].min * rand(0.5..1.5) # Decorrelated jitter between 0.5 and 1.5
  end

  def exceptions_to_retry_on
    [
      Faraday::ConnectionFailed,
      Faraday::TimeoutError,
      Faraday::ServerError
    ] + Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS
  end

  def enable_log_response?
    false
  end

  def enable_log_request?
    false
  end

  # SSL options for Faraday to use client certificate
  def use_certificate?
    false
  end

  def ssl_options
    return {} unless use_certificate?

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
