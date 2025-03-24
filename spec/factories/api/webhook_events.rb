# frozen_string_literal: true

# == Schema Information
#
# Table name: api_webhook_events
#
#  id            :uuid             not null, primary key
#  access_token  :string
#  callback_url  :string
#  event_type    :string
#  payload       :jsonb
#  response      :jsonb
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_client_id :uuid             not null
#  callback_id   :bigint
#  event_id      :uuid
#  job_id        :string
#
# Indexes
#
#  index_api_webhook_events_on_api_client_id  (api_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
#
FactoryBot.define do
  factory :api_webhook_event, class: 'API::WebhookEvent' do
    callback_url { Faker::Internet.url }
    event_id { rand(1..100) }
    status { 'received' }

    client factory: :api_client
  end
end
