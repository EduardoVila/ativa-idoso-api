# frozen_string_literal: true

# == Schema Information
#
# Table name: api_webhook_events
#
#  id            :bigint           not null, primary key
#  callback_url  :string
#  event_type    :string
#  payload       :jsonb
#  requester     :integer          default("guarantor")
#  response      :jsonb
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_client_id :bigint           not null
#  callback_id   :bigint
#  event_id      :bigint
#  job_id        :uuid
#
# Indexes
#
#  index_api_webhook_events_on_api_client_id  (api_client_id)
#  index_api_webhook_events_on_callback_id    (callback_id)
#  index_api_webhook_events_on_callback_url   (callback_url)
#  index_api_webhook_events_on_event_id       (event_id)
#  index_api_webhook_events_on_event_type     (event_type)
#  index_api_webhook_events_on_requester      (requester)
#  index_api_webhook_events_on_status         (status)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
#

module Api
  class WebhookEvent < ApplicationRecord
    belongs_to :client, class_name: 'Api::Client', foreign_key: 'api_client_id'

    enum :status, %i[received processing processed error]
    enum :requester, %i[guarantor analyzes]

    validates :status, inclusion: { in: statuses.keys }
    validates :requester, inclusion: { in: requesters.keys }
    validates :callback_url,
              presence: true,
              format: { with: URI::DEFAULT_PARSER.make_regexp }
  end
end
