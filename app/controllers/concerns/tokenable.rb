require 'jwt'
require 'dotenv/load'
require_relative '../../models/api/client' # Ensure you require the Client model

module Tokenable
  # Generate a JWT token
  def self.encode_token(payload)
    JWT.encode(payload, ENV.fetch('JWT_SECRET', nil), 'HS256')
  end

  # Decode the JWT token and return the payload
  def self.decode_token(token)
    JWT.decode(token, ENV.fetch('JWT_SECRET', nil), true,
               { algorithm: 'HS256' }).first
  rescue JWT::DecodeError
    nil # Return nil if the token is invalid
  end

  # Method to authenticate a client based on client_id and client_secret
  def self.authenticate(client_id, client_secret)
    client = API::Client.find_by(client_id: client_id)

    return unless client&.authenticate(client_secret)

    payload = { client_id: client_id, exp: Time.now.to_i + 3600 } # 1-hour expiration
    encode_token(payload)
  end
end
