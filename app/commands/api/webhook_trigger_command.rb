# frozen_string_literal: true

require_relative 'webhook_trigger_command_error'

module Api
  class WebhookTriggerCommand < ApplicationCommand
    def initialize(webhook_event, integrator = Api::WebhookEventIntegrator)
      @webhook_event = webhook_event
      @webhook_subscription = webhook_event&.api_webhook_subscription
      @integrator = integrator
      super()
    end

    def call
      return if webhook_event.blank? || webhook_event.processed?

      integrator.new.create_resource(webhook_event, webhook_subscription)
    end

    private

    attr_reader :webhook_event, :webhook_subscription, :integrator
  end
end
