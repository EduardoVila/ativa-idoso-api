# frozen_string_literal: true

#
### Idempotency Middleware
#
# 1. **Check Cache First**
#    – See if a prior request with the same key is already completed. If yes, return the
# cached response immediately.
#
# 2. **Acquire a Redis Lock**
#    – Attempt to set the lock key. If this succeeds, the request can proceed to compute
# the final response.
#    – If it fails (because another request holds the lock), we either:
#      (a) Poll for a short time, waiting for the other request’s result. Return it if
# found.
#      (b) Or return an immediate error (e.g., 409 Conflict).
#
# 3. **Compute and Cache**
#    – Process the request by calling the next handler, capture the response, and read
# its body.
#    – Store the final response in Redis with an expiration time (TTL). Any subsequent
# requests use this cached result.
#
# 4. **Release the Lock**
#    – In the finally block, delete the lock key so future requests can generate or
# reuse the response.
#
# ### Advantages Over a Simple Cache-Only Approach
#
# - **Concurrency Control:** Prevents multiple servers or threads from duplicating work
# if they receive the same idempotency key at nearly the same time.
# - **Persistence:** Data remains in Redis, surviving process restarts (assuming you’re
# not using Redis in ephemeral mode).
# - **TTL Management:** redis_client.setex ensures the result expires after a configured
# period (e.g., 7 days), preventing the cache from growing indefinitely.
#
# ### Production Considerations
#
# - **Lock Expiry:** If the request takes longer than REDIS_LOCK_EXPIRY (e.g. 10 seconds
# in the example), the lock expires. Another concurrent request could then incorrectly
# acquire the lock. Set a lock expiry that makes sense for your typical request
# processing time. You may also need to refresh the lock if you expect very long
# processing.
# - **Lock Contention Strategy:** Instead of polling, you could return 409 Conflict
# immediately, or use more sophisticated approaches like a queue or “pending”
# placeholder.
# - **Body Size & Performance:** Reading large response bodies into memory might be
# expensive. If your responses are large, consider streaming them or storing them in an
# object store if necessary.
#
# This pattern is suitable for distributed environments where multiple application
# instances need idempotent behavior.
require 'rack'
require 'json'

# uuid regex
REGEX = /
\A[a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\z/x
class Idempotency
  def initialize(app, lock_expiry: 10, cache_expiry: 86_400)
    @app = app
    @lock_expiry = lock_expiry       # seconds
    @cache_expiry = cache_expiry     # seconds (1 days default)
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
    lock_acquired = attempt_lock?(lock_key)

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
      [409, {}, ['The process has not been completed yet. Try again later.']]
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

  def attempt_lock?(lock_key)
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
