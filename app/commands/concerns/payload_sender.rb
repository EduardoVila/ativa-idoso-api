# frozen_string_literal: true

require_relative 'payload_sender_response_error'

module PayloadSender
  class << self
    def send(payload, report)
      response = perform_post_request(payload, report)

      raise PayloadSender::ResponseError unless response.success?

      response
    rescue Faraday::ConnectionFailed, Net::OpenTimeout => e
      ErrorLogger.log(e)

      return unless response.present?

      ResponseLogger.log(response, 'payloader_sender', payload)

      raise PayloadSender::ResponseError
    end

    private

    def perform_post_request(payload, report)
      conn.post do |req|
        req.url payload
        req.headers['Content-Type'] = 'application/json'
        req.body = report.to_json

        RequestLogger.log(req)
      end
    end

    def conn(proxy: nil)
      ::Faraday.new(ssl: {}, proxy: proxy) do |f|
        f.request :url_encoded
        f.request(
          :retry,
          max: 9,
          interval: 0.1,
          exceptions: [Faraday::ConnectionFailed]
        )
        f.adapter :net_http
      end
    end
  end

  class ResponseError < StandardError; end
end
