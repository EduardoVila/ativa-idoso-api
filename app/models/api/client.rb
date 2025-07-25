# frozen_string_literal: true

# == Schema Information
#
# Table name: api_clients
#
#  id            :bigint           not null, primary key
#  client_secret :string           not null
#  description   :string
#  validators    :text             default(["blocked_negativity_validator", "exceeded_debits_validator", "protested_titles_validator", "provenir_has_obit_indication_validator", "provenir_family_holding_validator", "provenir_process_validator", "provenir_age_and_income_validator"]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :string           not null
#
require 'bcrypt'
require 'logger'
require 'colorize'

module Api
  class Client < ::ApplicationRecord
    before_validation :set_client_credentials, on: :create

    has_many :analysis_reports, class_name: 'Analysis::Report',
                                inverse_of: :api_client,
                                dependent: :destroy

    has_many :webhook_events, class_name: 'Api::WebhookEvent',
                              inverse_of: :api_client,
                              dependent: :destroy

    has_one :webhook_credential, class_name: 'Api::WebhookCredential',
                                 inverse_of: :api_client,
                                 dependent: :destroy

    validates :client_id, presence: true, uniqueness: true
    validates :client_secret, presence: true

    # Method to check if the provided client_secret matches the hashed one
    # returns the client if the secret is correct, otherwise nil
    def authenticate(secret)
      return unless BCrypt::Password.new(client_secret) == secret

      self
    end

    def hash_secret(secret = SecureRandom.hex(32))
      hashed_secret = BCrypt::Password.create(secret)

      update(client_secret: hashed_secret)

      hashed_secret
    end

    private

    def set_client_credentials
      self.client_id = SecureRandom.hex(32)

      return self.client_secret = hash_secret if client_secret.nil?

      self.client_secret = BCrypt::Password.create(client_secret)
    end
  end
end
