# frozen_string_literal: true

require 'openssl'  # Include OpenSSL library for encryption
require 'base64'   # Include Base64 for encoding/decoding

# Module for encrypting and decrypting sensitive data using AES-256-CBC
module Encryptable
  class << self
    # Encrypts data using AES-256-CBC encryption
    # @param data [String] The data to encrypt
    # @return [String] Base64 encoded string containing the IV and encrypted data
    def encrypt_sensitive_data(data)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = ENV.fetch('ENCRYPTION_KEY', nil) # Get encryption key from environment variable
      cipher.iv = iv = cipher.random_iv # Generate random initialization vector
      encrypted = cipher.update(data.to_s) + cipher.final
      # Combine IV and encrypted data, pack as base64 strings, then encode the whole thing
      Base64.strict_encode64([iv, encrypted].pack('m*m*'))
    end

    # Decrypts data that was encrypted with encrypt_sensitive_data
    # @param encrypted_data [String] The encrypted data to decrypt
    # @return [String] The decrypted data
    def decrypt_sensitive_data(encrypted_data)
      # Decode the data and unpack the IV and encrypted content
      iv, encrypted = Base64.strict_decode64(encrypted_data).unpack('m*m*')

      decipher = OpenSSL::Cipher.new('AES-256-CBC')
      decipher.decrypt
      decipher.key = ENV.fetch('ENCRYPTION_KEY', nil) # Use same key as encryption
      decipher.iv = iv # Use the IV that was used for encryption
      decipher.update(encrypted) + decipher.final
    end
  end
end
