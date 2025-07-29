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
require 'spec_helper'

RSpec.describe Api::WebhookEvent, type: :model do
  describe 'factories' do
    context 'with default traits' do
      subject { create :api_webhook_event }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:analysis_report)
        .class_name('Analysis::Report')
        .with_foreign_key('analysis_report_id')
    end

    it do
      expect(subject).to belong_to(:api_webhook_credential)
        .class_name('Api::WebhookCredential')
        .with_foreign_key('api_webhook_credential_id')
    end
  end

  describe 'enums' do
    it {
      expect(subject).to define_enum_for(:status)
        .with_values(%i[received processing processed error])
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:callback_url) }

    describe 'callback_url format validation' do
      it 'accepts valid URLs' do
        webhook_event = build(
          :api_webhook_event, callback_url: 'https://example.com/webhook'
        )

        expect(webhook_event).to be_valid
      end

      it 'rejects invalid URLs' do
        webhook_event = build :api_webhook_event, callback_url: 'invalid-url'

        expect(webhook_event).not_to be_valid
        expect(webhook_event.errors[:callback_url]).to be_present
      end
    end
  end
end
