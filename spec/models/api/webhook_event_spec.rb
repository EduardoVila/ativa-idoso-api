# frozen_string_literal: true

# == Schema Information
#
# Table name: api_webhook_events
#
#  id            :bigint           not null, primary key
#  callback_url  :string
#  event_type    :string
#  payload       :jsonb
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
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
#
require 'spec_helper'

RSpec.describe API::WebhookEvent, type: :model do
  describe 'factories' do
    context 'with default traits' do
      subject { create :api_webhook_event }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:client) }
  end
end
