# frozen_string_literal: true

class RetryJob < ApplicationJob
  queue_as :retry

  def perform(analysis_report_id)
    analysis_report = find_analysis_report(analysis_report_id)
    webhook_event = find_webhook_event(analysis_report.id)

    return unless analysis_report.items.any? { |item| item.status == 'error' }

    process_analysis_report(analysis_report)
    process_webhook_event(webhook_event)

    process_items_with_error_status(analysis_report)

    update_webhook_event_payload(webhook_event, analysis_report)
    trigger_webhook_event(webhook_event)
  end

  private

  def find_analysis_report(analysis_report_id)
    Analysis::Report.find(analysis_report_id)
  end

  def find_webhook_event(analysis_report_id)
    API::WebhookEvent.find_by(event_id: analysis_report_id)
  end

  def process_webhook_event(webhook_event)
    webhook_event.update(status: :processing, job_id: job_id)
  end

  def process_analysis_report(analysis_report)
    analysis_report.update(status: :wip)
  end

  def process_items_with_error_status(analysis_report)
    analysis_report.items.where(status: 'error').each do |analysis_item|
      Invoker.execute(:analysis_item_runner_command, analysis_item)
    end
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
