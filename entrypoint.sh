#!/bin/sh
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Waiting for Postgres..."

# Run database migrations
if [ "$RUN_MIGRATIONS" = "true" ]; then
bundle exec erb config/database.yml
  echo "Creating database..."
  bundle exec rake db:create
  echo "Running database migrations..."
  bundle exec rake db:migrate
else
  echo "Skipping database migrations."
fi

exec "$@"
