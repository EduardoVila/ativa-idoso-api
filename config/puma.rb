# frozen_string_literal: true

# Specifies the number of worker processes to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
workers ENV.fetch('WEB_CONCURRENCY', 2)

# Specifies the `min` and `max` threads per worker.
threads_count = ENV.fetch('MAX_THREADS', 5)
threads threads_count, threads_count

# Preload the application before forking workers for faster worker spawn times.
preload_app!

# Specifies the port that Puma will listen on to receive requests.
port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('ENVIRONMENT', 'development')

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the `state_path` that Puma will use.
state_path ENV.fetch('STATE_PATH', 'tmp/pids/puma.state')
