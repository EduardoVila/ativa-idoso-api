# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'

module Tokenable
  class << self
    KEY_PREFIX = 'public_key:'

    # Generate a JWT token with the given payload signed with the RSA private key.
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

    # Verifies the JWT token and return the payload
    def verify(token)
      decoded_token = JWT.decode(token, nil, false) # Decode the token without verifying it

      # Extract the issuer from the decoded token
      issuer = decoded_token[0]['iss']

      # Find the public key object by issuer
      public_key_object = fetch_public_key(issuer)
      public_key = public_key_object[:key]
      algorithm = public_key_object[:algorithm]

      # Create a new RSA key object with the public key
      rsa_key = OpenSSL::PKey::RSA.new(public_key)

      # Decode the JWT, verifying it with the public key and algorithm
      decoded_payload = JWT.decode(token, rsa_key, true, { algorithm: })

      # Check if the token is expired
      # The first element of the decoded payload is the actual data
      check_expiration(decoded_payload.first)

      decoded_payload.first # Return the payload (decoded and verified data from jwt)
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

    def authenticate_access_token(request)
      authorization_header = request.env['HTTP_AUTHORIZATION']
      token = authorization_header&.split&.last

      return 401 unless token

      payload = Tokenable.verify(token)

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

      payload = Tokenable.verify(token)

      return unless payload

      begin
        API::Client.find_by_client_id(payload['sub'])
      rescue NoMethodError
        halt 404
      rescue JWT::ExpiredSignature, JWT::DecodeError
        halt 401
      end
    end

    def fetch_public_key(issuer)
      cache_key = cache_key_for(issuer)

      cached_key = RedisCache.get(cache_key)
      return cached_key if cached_key

      public_key_record = fetch_public_key_record(issuer)
      store_in_cache(cache_key, public_key_record)

      public_key_record
    end

    private

    def cache_key_for(issuer)
      "#{KEY_PREFIX}#{issuer}"
    end

    def fetch_public_key_record(issuer)
      PublicKey.find_by(issuer: issuer) ||
        raise("Public key not found for issuer: #{issuer}")
    end

    def store_in_cache(cache_key, public_key_record)
      value = {
        key: public_key_record.key,
        algorithm: public_key_record.algorithm
      }
      RedisCache.set(cache_key, value)
    end
  end
end

class ExpiredTokenError < StandardError; end
class InvalidTokenError < StandardError; end
