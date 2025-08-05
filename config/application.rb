# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

%i[
  load_gems
  load_app
  load_sidekiq
  load_redis_cache
  load_sentry
].each { |method| ApplicationLoader.public_send(method) }

# Start the application
class AlpopAnalysis < Sinatra::Base
  # Middleware
  use Idempotency

  # Endpoint handlers
  use V1::Authenticate
  use V1::CreateAnalysisReport
  use V1::NextAnalysisStep
  use V1::RerunCloneAnalysisItem
  use V1::RetryAnalysisReport
  use V1::ShowAnalysisReport

  # Health check endpoint
  get '/' do
    headers 'Content-Type' => 'application/json'
    { message: 'Analysis API is running.' }.to_json
  end
end
