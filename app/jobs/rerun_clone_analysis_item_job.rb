# frozen_string_literal: true

class RerunCloneAnalysisItemJob
  include Sidekiq::Job

  sidekiq_options queue: :rerun_clone_analysis_item, retry: 3

  def perform(analysis_item_id)
    analysis_item = find_analysis_item(analysis_item_id)
    webhook_event = find_webhook_event(analysis_item.analysis_report_id)
    analysis_report = analysis_item.report

    return if analysis_item.clone_of_id.blank?

    ApplicationRecord.transaction do
      webhook_event.update!(status: :processing, job_id: jid)
      analysis_item.update!(clone_of_id: nil, status: :todo, name: nil)
      analysis_report.update!(status: :wip)
      analysis_item.predictions.destroy_all
      analysis_item.steps.destroy_all
    end

    process_analysis_item(analysis_item)

    update_webhook_event_payload(webhook_event, analysis_report)
    trigger_webhook_event(webhook_event)
  end

  private

  def find_analysis_item(analysis_item_id)
    Analysis::Item.find(analysis_item_id)
  end

  def find_webhook_event(analysis_report_id)
    Api::WebhookEvent.find_by(event_id: analysis_report_id)
  end

  def process_analysis_item(analysis_item)
    Invoker.execute(:analysis_item_runner_command, analysis_item)
  end

  def update_webhook_event_payload(webhook_event, analysis_report)
    webhook_event.update(payload: analysis_report.reload.serialize_record)
  end

  def trigger_webhook_event(webhook_event)
    Invoker.execute(:api_webhook_trigger_command, webhook_event)
  end
end
