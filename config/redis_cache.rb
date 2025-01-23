# frozen_string_literal: true

require 'sidekiq'
require 'json'

module RedisCache
  REDIS_POOL = Sidekiq::RedisConnection.create(url: ENV.fetch('REDIS_URL'))

  module_function

  # Returns a Redis connection from the pool
  #
  # @return [Redis] the Redis connection instance
  def redis
    REDIS_POOL.with { |conn| conn }
  end

  # Store a value in Redis with an optional expiration time (in seconds)
  #
  # @param key [String] the key under which the value will be stored
  # @param value [Object] the value to be stored
  # @param ttl [Integer, nil] the time-to-live in seconds (optional)
  # @return [String, Boolean] 'OK' if successful, true if the key was set, false if not
  def set(key, value, ttl: nil)
    value = value.to_json
    ttl ? redis.setex(key, ttl, value) : redis.set(key, value)
  end

  # Retrieve a value from Redis and parse it as JSON
  #
  # @param key [String] the key of the value to retrieve
  # @return [Hash, nil] the parsed JSON value or nil if the key does not exist
  def get(key)
    value = redis.get(key)
    value ? JSON.parse(value, symbolize_names: true) : nil
  end

  # Delete a specific key from Redis
  #
  # @param key [String] the key to delete
  # @return [Integer] the number of keys that were removed
  def delete(key)
    redis.del(key)
  end

  # Check if a key exists in Redis
  #
  # @param key [String] the key to check
  # @return [Boolean] true if the key exists, false otherwise
  def exists?(key)
    redis.exists?(key) == 1
  end

  # Retrieve all stored keys in Redis
  #
  # @return [Array<String>] an array of all keys
  def all_keys
    redis.keys('*')
  end

  # Retrieve all cached objects as a hash
  #
  # @return [Hash] a hash of all cached objects with keys as strings and values as parsed JSON
  def all_cached_objects
    all_keys.each_with_object({}) do |key, hash|
      value = redis.get(key)
      hash[key] = JSON.parse(value, symbolize_names: true) if value
    end
  end

  # Clear all keys in Redis
  #
  # @return [Integer] the number of keys that were removed
  def clear_all
    keys = all_keys
    redis.del(*keys) unless keys.empty?
  end
end
