# frozen_string_literal: true

# == Schema Information
#
# Table name: api_webhook_events
#
#  id            :bigint           not null, primary key
#  access_token  :string
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
require 'bcrypt'

module API
  class WebhookEvent < ApplicationRecord
    before_create :hash_access_token

    belongs_to :client, class_name: 'API::Client',
                        foreign_key: 'api_client_id'

    enum :status, %i[received processing processed error]

    validates :status, inclusion: { in: statuses.keys }
    validates :callback_url,
              presence: true,
              format: { with: URI::DEFAULT_PARSER.make_regexp }

    private

    def hash_access_token
      return unless access_token.present?

      self.access_token = BCrypt::Password.create(access_token)
    end
  end
end
