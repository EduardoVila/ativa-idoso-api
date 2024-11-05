# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'faraday/net_http'

module Integrable
  extend ActiveSupport::Concern

  def conn
    ::Faraday.new(ssl: ssl_options) do |f|
      f.request :url_encoded
      f.adapter :net_http
      f.request :retry, max: 3, interval: 0.05
    end
  end

  def do_request(verb, url, headers, params = nil, proxy = nil)
    send(:"do_#{verb}_request", url, headers, params, proxy)
  end

  private

  def do_get_request(url, headers, params, proxy)
    get_conn = conn
    get_conn.proxy = proxy

    get_conn.get do |req|
      req.url url
      req.headers = headers
      req.body = params
    end
  end

  def do_post_request(url, headers, params, proxy)
    post_conn = conn
    post_conn.proxy = proxy

    post_conn.post do |req|
      req.url url
      req.headers = headers
      req.body = params
    end
  end

  def do_put_request(url, headers, params, proxy)
    put_conn = conn
    put_conn.proxy = proxy

    put_conn.put do |req|
      req.url url
      req.headers = headers
      req.body = params
    end
  end

  def do_patch_request(url, headers, params, proxy)
    patch_conn = conn
    patch_conn.proxy = proxy

    patch_conn.patch do |req|
      req.url url
      req.headers = headers
      req.body = params
    end
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
