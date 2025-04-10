# frozen_string_literal: true

require_relative 'application_job'

class AnalysisStepJob < ApplicationJob
  queue_as :analysis_step

  def perform(analysis_item_id, analysis_step_name)
    return if analysis_item_id.blank? || analysis_step_name.blank?

    analysis_item = find_analysis_item(analysis_item_id)
    analysis_step = find_analysis_step(analysis_step_name)
    webhook_event = find_webhook_event(analysis_item.analysis_report_id)

    if analysis_item.blank? ||
       analysis_step.blank? ||
       webhook_event.blank? ||
       analysis_item.steps.find_by(id: analysis_step_name).present?

      return
    end

    ApplicationRecord.transaction do
      webhook_event.update!(status: :processing, job_id: job_id)
      analysis_item.update!(status: :wip)
    end

    invoke_step(analysis_item, analysis_step.command_class)

    update_webhook_event_payload(webhook_event, analysis_item.report)
    trigger_webhook_event(webhook_event)
  end

  private

  def find_webhook_event(analysis_report_id)
    Api::WebhookEvent.find_by(event_id: analysis_report_id)
  end

  def find_analysis_item(analysis_item_id)
    Analysis::Item.find(analysis_item_id)
  end

  def find_analysis_step(analysis_step_name)
    Analysis::Step.find_by(name: analysis_step_name)
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
