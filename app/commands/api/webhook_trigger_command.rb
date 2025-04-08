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
      webhook_event.update(status: :error, response: e.message)
      Analysis::Report.find(webhook_event.event_id).update(status: :error)
      raise e
    end
  end
end
