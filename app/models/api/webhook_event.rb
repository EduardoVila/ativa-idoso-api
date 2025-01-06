# frozen_string_literal: true

require 'bcrypt'
require_relative '../application_record'

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
