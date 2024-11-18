# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'
require_relative '../../models/api/client' # Ensure you require the Client model

module Tokenable
  # Generate a JWT token
  def self.encode(payload)
    JWT.encode(payload, ENV.fetch('JWT_SECRET'), 'HS256')
  end

  # Decode the JWT token and return the payload
  def self.decode(token)
    JWT.decode(token, ENV.fetch('JWT_SECRET'), true, { algorithm: 'HS256' })
      .first
  rescue JWT::DecodeError
    nil # Return nil if the token is invalid
  end

  # Method to authenticate a client based on client_id and client_secret
  # Returns a JWT token if the client is authenticated
  def self.create_access_token(client_id, client_secret)
    client = API::Client.find_by_client_id client_id

    return unless client&.authenticate(client_secret) # Authenticate the client

    payload = { client_id: client_id, exp: Time.now.to_i + 10_080 } # 7 days in minutes
    encode(payload)
  end

  def self.authenticate_access_token(request)
    authorization_header = request.env['HTTP_AUTHORIZATION']
    token = authorization_header&.split&.last

    return 401 unless token

    decoded_token = Tokenable.decode token

    return 401 unless decoded_token

    client_id = decoded_token['client_id']

    begin
      200 if API::Client.find_by_client_id client_id
    rescue NoMethodError
      404
    rescue JWT::ExpiredSignature, JWT::DecodeError
      401
    end
  end

  def self.current_client(request)
    authorization_header = request.env['HTTP_AUTHORIZATION']
    token = authorization_header&.split&.last

    return nil unless token

    decoded_token = Tokenable.decode token

    return nil unless decoded_token

    client_id = decoded_token['client_id']

    API::Client.find_by_client_id client_id
  end
end
