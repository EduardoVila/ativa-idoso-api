# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'

module Tokenable # rubocop:disable Metrics/ModuleLength
  class << self
    KEY_PREFIX = 'public_key:'

    # Generate a JWT token with the given payload
    # @param payload [Hash] Custom claims to include in the token
    # @param expires_in [Integer] Token expiration time in seconds
    # @return [String] Encoded JWT token
    # @raise [ArgumentError] If payload is invalid
    # @raise [StandardError] If token creation fails
    def create_jwt(payload:, expires_in: ENV.fetch('SECONDS').to_i)
      validate_payload!(payload)

      jwt_payload = build_payload(payload, expires_in)
      private_key = load_private_key
      algorithm = fetch_algorithm

      JWT.encode(jwt_payload, private_key, algorithm)
    rescue OpenSSL::PKey::RSAError => e
      raise "Invalid RSA private key: #{e.message}"
    rescue KeyError => e
      raise "Missing environment variable: #{e.message}"
    rescue StandardError => e
      raise "JWT creation failed: #{e.message}"
    end

    # Verify and decode a JWT token
    # @param token [String] JWT token to verify
    # @return [Hash] Decoded token payload
    # @raise [TokenError] If token is invalid or expired
    def verify(token)
      raise ArgumentError, 'Token cannot be blank' if token.blank?

      issuer = extract_issuer(token)
      public_key = fetch_public_key_for_issuer(issuer)

      decode_and_verify_token(token, public_key)
    rescue JWT::ExpiredSignature
      raise TokenExpiredError, 'Token has expired'
    rescue JWT::DecodeError
      raise InvalidTokenError, 'Token is invalid or malformed'
    rescue StandardError => e
      raise TokenVerificationError, "Verification failed: #{e.message}"
    end

    # Get authenticated client from request
    # @param request [Sinatra::Request] Current request object
    # @return [Api::Client, nil] Authenticated client or nil
    def current_client(request)
      token = extract_bearer_token(request)
      return nil if token.blank?

      authenticate_client_with_token(token)
    rescue StandardError => e
      request.logger.error "Authentication failed: #{e.message}"
      nil
    end

    private

    def validate_payload!(payload)
      raise ArgumentError, 'Payload must be a Hash' unless payload.is_a?(Hash)
      raise ArgumentError, 'Payload cannot be empty' if payload.empty?
    end

    def build_payload(custom_payload, expires_in)
      {
        'exp' => Time.now.to_i + expires_in,
        'iss' => ENV.fetch('JWT_ISSUER'),
        'iat' => Time.now.to_i
      }.merge(custom_payload)
    end

    def load_private_key
      private_key_string = ENV.fetch('RSA_PRIVATE_KEY')
        .gsub('\\n', "\n")

      OpenSSL::PKey::RSA.new(private_key_string)
    end

    def fetch_algorithm
      ENV.fetch('JWT_ALGORITHM')
    end

    def extract_issuer(token)
      decoded_token = JWT.decode(token, nil, false)
      issuer = decoded_token.first['iss']

      raise MissingIssuerError, 'Token is missing issuer claim' if issuer.blank?

      issuer
    rescue JWT::DecodeError
      raise InvalidTokenError, 'Unable to decode token'
    end

    def fetch_public_key_for_issuer(issuer)
      public_key_object = fetch_public_key(issuer)
      rsa_key = OpenSSL::PKey::RSA.new(public_key_object[:key])

      {
        key: rsa_key,
        algorithm: public_key_object[:algorithm]
      }
    rescue OpenSSL::PKey::RSAError
      raise InvalidPublicKeyError, 'Invalid RSA public key'
    rescue StandardError => e
      raise PublicKeyFetchError, "Failed to fetch public key: #{e.message}"
    end

    def fetch_public_key(issuer)
      cache_key = cache_key_for(issuer)

      cached_key = RedisCache.get(cache_key)
      return cached_key if cached_key

      public_key_record = fetch_public_key_record(issuer)
      store_in_cache(cache_key, public_key_record)

      public_key_record
    end

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

    def decode_and_verify_token(token, public_key)
      decoded_payload = JWT.decode(
        token,
        public_key[:key],
        true,
        { algorithm: public_key[:algorithm] }
      )

      verify_expiration!(decoded_payload.first)

      decoded_payload.first
    end

    def verify_expiration!(payload)
      expiration_time = payload['exp']

      if expiration_time.nil?
        raise InvalidTokenError, 'Token missing expiration claim'
      end

      return unless Time.now.to_i > expiration_time

      raise JWT::ExpiredSignature
    end

    def extract_bearer_token(request)
      auth_header = request.env['HTTP_AUTHORIZATION']
      return nil if auth_header.blank?

      bearer, token = auth_header.split
      return nil unless bearer&.downcase == 'bearer' && token

      token
    end

    def authenticate_client_with_token(token)
      payload = verify(token)
      return nil if payload.blank?

      client_id = payload['sub']
      return nil if client_id.blank?

      Api::Client.find_by_client_id(client_id)
    rescue JWT::ExpiredSignature, JWT::DecodeError, NoMethodError => e
      request.logger.info "Token validation failed: #{e.message}"
      nil
    end

    # Custom error classes
    class TokenError < StandardError; end
    TokenError.freeze
    class TokenExpiredError < TokenError; end
    TokenExpiredError.freeze
    class InvalidTokenError < TokenError; end
    InvalidTokenError.freeze
    class TokenVerificationError < TokenError; end
    TokenVerificationError.freeze
    class MissingIssuerError < TokenError; end
    MissingIssuerError.freeze
    class InvalidPublicKeyError < TokenError; end
    InvalidPublicKeyError.freeze
    class PublicKeyFetchError < TokenError; end
    PublicKeyFetchError.freeze
  end
end
