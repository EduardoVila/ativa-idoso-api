class ChangingTypeOfJobIdColumnInApiWebhookEvent < ActiveRecord::Migration[8.0]
  def change
    change_column :api_webhook_events, :job_id, :string
  end
end
