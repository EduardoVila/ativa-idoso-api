# frozen_string_literal: true

require_relative 'payload_sender_response_error'
require_relative '../../../app/integrators/concerns/integrable'

module PayloadSender
  class << self
    include Integrable

    def send(payload, report)
      response = perform_post_request(payload, report)

      raise PayloadSender::ResponseError unless response.success?

      response
    rescue Faraday::ConnectionFailed, Net::OpenTimeout => e
      ErrorLogger.log(e)

      return unless response.present?

      ResponseLogger.log(response, 'payloader_sender', payload)

      raise e
    end

    private

    def perform_post_request(payload, report)
      integrable_conn = conn # conn method is defined in Integrable module

      integrable_conn.post do |req|
        req.url payload
        req.headers['Content-Type'] = 'application/json'
        req.body = report.to_json

        RequestLogger.log(req)
      end
    end
  end
end
