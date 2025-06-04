# frozen_string_literal: true

require 'redis'
require 'json'

module RedisCache
  # Create a connection pool with 5 connections and a 5-second timeout for each connection attempt
  REDIS_POOL = ConnectionPool.new(
    size: EnvHelper.fetch('REDIS_POOL_SIZE').to_i,
    timeout: 5
  ) do
    Redis.new(url: EnvHelper.fetch('STACKHERO_REDIS_URL_CLEAR')) # Create a new Redis connection for each thread that needs one (up to 5)
  end

  module_function # Make all methods in this module available as module functions

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
  # @param ttl [Integer] the time-to-live in seconds for the key (default: 1 day or 86,400 seconds)
  #                    After this time has passed, the key will be automatically deleted by Redis.
  # @return [String, Boolean] 'OK' if successful, true if the key was set, false if not
  def set(key, value, ttl: EnvHelper.fetch('REDIS_TTL', 86_400).to_i)
    redis.setex(key, ttl, value.to_json)
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
