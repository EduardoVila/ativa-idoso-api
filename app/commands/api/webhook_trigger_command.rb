# frozen_string_literal: true

require_relative '../../integrators/concerns/integrable'
require_relative '../../integrators/concerns/parseable'
require_relative 'webhook_trigger_command_error'

module API
  class WebhookTriggerCommand < ApplicationCommand
    include Integrable
    include Parseable

    attr_reader :webhook_event

    def initialize(webhook_event)
      super()
      @webhook_event = webhook_event
    end

    def call
      return if webhook_event.processed? # Guard clause to avoid unnecessary calls

      response = perform_post_request(webhook_event)

      raise API::WebhookTriggerCommandError unless response.success?

      parsed_response_body = parser(response.body)

      webhook_event.update(status: :processed, response: parsed_response_body)

      webhook_event
    rescue Faraday::ConnectionFailed, API::WebhookTriggerCommandError => e
      ErrorLogger.log(e)

      webhook_event.update(status: :error, response: e.message)

      webhook_event
    end

    private

    def perform_post_request(webhook_event)
      do_request(
        :post, url(webhook_event), webhook_headers, body(webhook_event)
      )
    end

    def url(webhook_event)
      webhook_event.callback_url
    end

    def webhook_headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def body(webhook_event)
      webhook_event.payload.to_json
    end
  end
end
