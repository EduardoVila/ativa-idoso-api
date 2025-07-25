# frozen_string_literal: true

require_relative 'webhook_trigger_command_error'

module Api
  class WebhookTriggerCommand < ApplicationCommand
    def initialize(webhook_event, integrator = Api::WebhookEventIntegrator)
      @webhook_event = webhook_event
      @integrator = integrator
      super()
    end

    def call
      return if webhook_event.blank? ||
                webhook_credential.blank? ||
                webhook_event.processed?

      integrator.new.create_resource(webhook_event, webhook_credential)
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

    private

    attr_reader :webhook_event, :integrator

    def webhook_credential
      @webhook_credential ||= Api::WebhookCredential.find_by(
        api_client: webhook_event.api_client
      )
    end
  end
end
