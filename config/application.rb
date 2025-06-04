# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

ApplicationLoader.load_gems
ApplicationLoader.load_app
ApplicationLoader.load_sidekiq
ApplicationLoader.load_redis_cache
ApplicationLoader.load_sentry

# Start the application
class AlpopAnalysis < Sinatra::Base
  use Idempotency
  use V1::Authenticate
  use V1::CreateAnalysisReport
  use V1::NextAnalysisStep
  use V1::RerunCloneAnalysisItem
  use V1::RetryAnalysisReport
  use V1::ShowAnalysisReport
  use Rack::SslEnforcer, hsts: { subdomains: true }, only_https: true
  use Rack::Protection

  get '/' do
    headers 'Content-Type' => 'application/json'
    { message: 'Analysis API is running.' }.to_json
  end
end
