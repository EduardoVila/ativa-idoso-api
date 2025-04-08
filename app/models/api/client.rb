# frozen_string_literal: true

# == Schema Information
#
# Table name: api_clients
#
#  id            :bigint           not null, primary key
#  client_secret :string           not null
#  description   :string
#  name          :string
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
                              inverse_of: :client,
                              dependent: :destroy

    validates :client_id, presence: true, uniqueness: true
    validates :client_secret, presence: true

    # Method to check if the provided client_secret matches the hashed one
    # returns the client if the secret is correct, otherwise nil
    def authenticate(secret)
      return unless BCrypt::Password.new(client_secret) == secret

      self
    end

    private

    def set_client_credentials
      self.client_id = SecureRandom.hex(32)
      client_secret = SecureRandom.hex(32)

      encoded_client_id = Base64.strict_encode64(client_id)
      encoded_client_secret = Base64.strict_encode64(client_secret)

      unless AlpopAnalysis.settings.test?
        # Log the client credentials to the console for admin use
        logger = Logger.new($stdout)
        logger.info(
          "#{'Database populated with new client:'.green.bold}\n\n" \
          "client_id: #{client_id.yellow.bold}\n" \
          "client_secret: #{client_secret.yellow.bold}\n\n" \
          "strict base64 client_id: #{encoded_client_id.yellow.bold}\n" \
          "strict base64 client_secret: #{encoded_client_secret.yellow.bold}\n"
        )
      end

      # Hash the client_secret before saving it to the database
      self.client_secret = BCrypt::Password.create(client_secret)
    end
  end
end
