# frozen_string_literal: true

require_relative '../application_record'

module API
  class WebhookEvent < ApplicationRecord
    belongs_to :client, class_name: 'API::Client',
                        foreign_key: 'api_client_id'

    enum :status, %i[received processing success error]

    validates :status, inclusion: { in: statuses.keys }
  end
end
