# frozen_string_literal: true

require_relative 'webhook_trigger_command_error'

module Api
  class WebhookTriggerCommand < ApplicationCommand
    attr_reader :webhook_event

    def initialize(webhook_event)
      super()
      @webhook_event = webhook_event
    end

    def call
      return if webhook_event.processed? # Guard clause to avoid unnecessary calls

      integrator = Api::WebhookIntegrator.new
      integrator.create_resource(webhook_event)
    rescue ::Errors::Api::WebhookPostResponseError, StandardError => e
      logger = Logger.new($stdout)
      logger.error(
        <<~ERR
          Failed to deliver Webhook Event #{webhook_event.id} to #{webhook_event.callback_url}.
          Exception: #{e}
        ERR
      )

      raise e # Raise error to be handled by Sidekiq retries
    end
  end
end
