# frozen_string_literal: true

require 'rack'
require 'json'

REGEX = /\A[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\z/x

class Idempotency
  def initialize(app, lock_expiry: 10, cache_expiry: 86_400)
    @app = app
    @lock_expiry = lock_expiry       # seconds
    @cache_expiry = cache_expiry     # seconds (7 days default)
  end

  def call(env)
    request = Rack::Request.new(env)
    return @app.call(env) unless request.post?

    idempotency_key, error_response = validate_idempotency_key(request)
    return error_response if error_response

    cache_key = "idempotency:#{idempotency_key}"
    lock_key  = "#{cache_key}:lock"

    # 1) Check existing cache
    if (cached_data = fetch_cache(cache_key))
      return [cached_data[:status_code], {}, [cached_data[:content]]]
    end

    # 2) Acquire lock in a basic (non-atomic) manner
    lock_acquired = attempt_lock(lock_key)

    return handle_lock_failure(cache_key) unless lock_acquired

    begin
      # 3) Call the next app component
      status, headers, body = @app.call(env)

      # Gather response body
      response_body = body.map { |chunk| chunk }
      body.close if body.respond_to?(:close)
      final_body = response_body.join

      # 4) Cache the result
      store_cache(
        cache_key,
        { content: final_body, status_code: status },
        @cache_expiry
      )

      [status, headers, [final_body]]
    ensure
      # 5) Release the lock
      release_lock(lock_key)
    end
  end

  private

  def handle_lock_failure(cache_key)
    cached_data = poll_for_cache(cache_key, @lock_expiry)
    if cached_data
      [cached_data[:status_code], {}, [cached_data[:content]]]
    else
      [409, {},
       ['Request could not be completed due to concurrent processing']]
    end
  end

  def validate_idempotency_key(request)
    idempotency_key = request.get_header('HTTP_IDEMPOTENCY_KEY') ||
                      request.get_header('HTTP_X_IDEMPOTENCY_KEY')
    if idempotency_key.nil?
      return [nil, [400, {}, ['Missing Idempotency-Key header']]]
    end

    unless idempotency_key.match?(REGEX)
      return [nil, [400, {}, ['Invalid Idempotency-Key format']]]
    end

    [idempotency_key, nil]
  end

  def fetch_cache(cache_key)
    RedisCache.get(cache_key)
  end

  def store_cache(cache_key, data, ttl)
    RedisCache.set(cache_key, data, ttl: ttl)
  end

  def attempt_lock(lock_key)
    return false if RedisCache.exists?(lock_key)

    RedisCache.set(lock_key, { locked: true }, ttl: @lock_expiry)
    true
  end

  def release_lock(lock_key)
    RedisCache.delete(lock_key)
  end

  # Poll for a cached result up to max_wait seconds
  def poll_for_cache(cache_key, max_wait)
    start_time = Time.now.to_f
    while (Time.now.to_f - start_time) < max_wait
      sleep(0.2)
      if (cached_data = fetch_cache(cache_key))
        return cached_data
      end
    end
    nil
  end
end
