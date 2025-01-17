# frozen_string_literal: true

require_relative 'application_job'

class AnalysisStepJob < ApplicationJob
  queue_as :analysis_step

  def perform(analysis_item_id, analysis_step_id)
    return if analysis_item_id.blank? || analysis_step_id.blank?

    analysis_item = find_analysis_item(analysis_item_id)
    analysis_step = find_analysis_step(analysis_step_id)
    webhook_event = find_webhook_event(analysis_item.analysis_report_id)

    if analysis_item.blank? ||
       analysis_step.blank? ||
       webhook_event.blank? ||
       analysis_item.steps.find_by(id: analysis_step_id).present?

      return
    end

    process_webhook_event(webhook_event)

    analysis_item.update(status: :wip)

    invoke_step(analysis_item, analysis_step.command_class)

    analysis_item.steps << analysis_step

    analysis_item.update(status: :done)

    update_webhook_event_payload(webhook_event, analysis_item.report)
    trigger_webhook_event(webhook_event)
  end

  private

  def find_webhook_event(analysis_report_id)
    API::WebhookEvent.find_by(event_id: analysis_report_id)
  end

  def find_analysis_item(analysis_item_id)
    Analysis::Item.find(analysis_item_id)
  end

  def find_analysis_step(analysis_step_id)
    Analysis::Step.find_by(id: analysis_step_id)
  end

  def process_webhook_event(webhook_event)
    webhook_event.update(status: 'processing', job_id: job_id)
  end

  def invoke_step(analysis_item, command_class)
    Invoker.execute(:a_step, analysis_item, command_class)
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
