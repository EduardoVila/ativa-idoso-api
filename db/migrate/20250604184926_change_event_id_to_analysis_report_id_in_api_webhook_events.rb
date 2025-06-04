class ChangeEventIdToAnalysisReportIdInApiWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :api_webhook_events, :event_id, :analysis_report_id

    add_foreign_key :api_webhook_events,
                    :analysis_reports,
                    column: :analysis_report_id
  end
end
