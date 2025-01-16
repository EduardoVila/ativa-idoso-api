# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'
require_relative '../../models/api/client'

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
    def create_jwt(payload:, expires_in: ENV.fetch('SECONDS').to_i)
      payload['exp'] = Time.now.to_i + expires_in
      payload['iss'] = 'alpop-analysis'
      payload['iat'] = Time.now.to_i

      # Load the RSA private key
      private_key = ENV['RSA_PRIVATE_KEY'].gsub('\\n', "\n") # Replace escaped newlines with actual newlines (\n)
      rsa_key = OpenSSL::PKey::RSA.new(private_key) # Create a new RSA key object

      algorithm = ENV.fetch('JWT_ALGORITHM')

      JWT.encode(payload, rsa_key, algorithm)
    end

    # Decode the JWT token and return the payload
    def verify_jwt(token)
      decoded_token = JWT.decode(token, nil, false) # Decode the token without verifying it

      issuer = decoded_token[0]['iss'] # Extract the issuer from the decoded token
      public_key = fetch_public_key_for(issuer) # Fetch the public key for the issuer
      rsa_key = OpenSSL::PKey::RSA.new(public_key) # Create a new RSA key object

      algorithm = ENV.fetch('JWT_ALGORITHM')

      # Decode the JWT, verifying it with the public key and algorithm
      decoded_payload = JWT.decode(token, rsa_key, true, { algorithm: })

      # Check if the token is expired
      # The first element of the decoded payload is the actual data
      check_expiration(decoded_payload.first)

      decoded_payload.first # Return the payload (decoded data)
    rescue JWT::ExpiredSignature
      raise ExpiredTokenError, 'Token has expired'
    rescue JWT::DecodeError
      raise InvalidTokenError, 'Invalid token'
    end

    def check_expiration(payload)
      expiration_time = payload['exp']

      return unless expiration_time && Time.now.to_i > expiration_time

      raise ExpiredTokenError, 'Token has expired'
    end

    def fetch_public_key_for(issuer)
      # Map each issuer to its public key

      public_keys = {
        'alpop-analysis' => OpenSSL::PKey::RSA.new(
          ENV.fetch('RSA_PUBLIC_KEY').gsub('\\n', "\n")
        ),
        'alpop-prediction' => OpenSSL::PKey::RSA.new(
          ENV.fetch('RSA_ALPOP_PREDICTION_PUBLIC_KEY').gsub('\\n', "\n")
        )
      }

      public_keys[issuer] # Replace escaped newlines with actual newlines (\n)
    end

    def authenticate_access_token(request)
      authorization_header = request.env['HTTP_AUTHORIZATION']
      token = authorization_header&.split&.last

      return 401 unless token

      payload = Tokenable.verify_jwt(token)

      return 401 unless payload

      begin
        200 if API::Client.find_by_client_id(payload['sub'])
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

      payload = Tokenable.verify_jwt(token)

      return unless payload

      begin
        API::Client.find_by_client_id(payload['sub'])
      rescue NoMethodError
        halt 404
      rescue JWT::ExpiredSignature, JWT::DecodeError
        halt 401
      end
    end
  end
end

class ExpiredTokenError < StandardError; end
class InvalidTokenError < StandardError; end
