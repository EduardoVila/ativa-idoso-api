# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

ApplicationLoader.load_gems
ApplicationLoader.load_app
ApplicationLoader.load_sidekiq_redis

# Start the application
class AlpopAnalysis < Sinatra::Base
  use V1::CreateAnalysisReport
  use V1::CreateToken
  use V1::NextAnalysisStep
  use V1::RerunAnalysisItem
  use V1::RetryAnalysisReport
  use V1::ShowAnalysisReport
  use Rack::Protection

  get '/' do
    'ok'
  end
end
