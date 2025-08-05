# frozen_string_literal: true

module Api
  class WebhookDeliveryService < ApplicationService
    def initialize(invoker = Invoker)
      @invoker = invoker
      super()
    end

    def call(webhook_events, analysis_report)
      return if webhook_events.blank? || analysis_report.blank?

      webhook_events.each do |webhook_event|
        next if webhook_event.processed?

        webhook_event.update!(payload: analysis_report.serialize_record)

        @invoker.execute(:api_webhook_trigger_command, webhook_event)
      end
    end
  end
end
