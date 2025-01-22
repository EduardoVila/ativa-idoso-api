# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'
require_relative '../../models/api/client' # Ensure you require the Client model

# Tokenable module provides methods to handle JWT token encoding, decoding,
# and client authentication.
# Use as concern in controllers to authenticate requests.
#
# Methods:
# - encode(payload): Generates a JWT token with the given payload.
# - decode(token): Decodes the JWT token and returns the payload.
#     Returns nil if the token is invalid.
# - create_access_token(client_id, client_secret): Authenticates a client based
#     on client_id and client_secret, and returns a JWT token if authenticated.
# - authenticate_access_token(request): Authenticates a request based on the JWT
#     token in the Authorization header. Returns HTTP status codes based on the
#     authentication result.
# - current_client(request): Retrieves the current client based on the JWT token
#     in the Authorization header. Returns the client object or halts with
#    appropriate HTTP status codes if authentication fails.
module Tokenable
  class << self
    # Generate a JWT token
    def encode(payload)
      JWT.encode(payload, ENV.fetch('JWT_SECRET'), 'HS256')
    end

    # Decode the JWT token and return the payload
    def decode(token)
      JWT.decode(token, ENV.fetch('JWT_SECRET'), true, { algorithm: 'HS256' })
        .first
    rescue JWT::DecodeError
      nil # Return nil if the token is invalid
    end

    # Method to authenticate a client based on client_id and client_secret
    # Returns a JWT token if the client is authenticated
    def create_access_token(client_id, client_secret)
      client = API::Client.find_by_client_id client_id

      return unless client&.authenticate(client_secret) # Authenticate the client

      payload = { client_id: client_id, exp: Time.now.to_i + 10_080 } # 7 days in minutes TODO: Move to ENV
      encode(payload)
    end

    def authenticate_access_token(request)
      authorization_header = request.env['HTTP_AUTHORIZATION']
      token = authorization_header&.split&.last

      return 401 unless token

      decoded_token = Tokenable.decode(token)

      return 401 unless decoded_token

      begin
        200 if API::Client.find_by_client_id(decoded_token['client_id'])
      rescue NoMethodError
        404
      rescue JWT::ExpiredSignature, JWT::DecodeError
        401
      end
    end

    def current_client(request)
      authorization_header = request.env['HTTP_AUTHORIZATION']
      token = authorization_header&.split&.last

      return unless token

      decoded_token = Tokenable.decode(token)

      return unless decoded_token

      begin
        API::Client.find_by_client_id(decoded_token['client_id'])
      rescue NoMethodError
        halt 404
      rescue JWT::ExpiredSignature, JWT::DecodeError
        halt 401
      end
    end
  end
end
