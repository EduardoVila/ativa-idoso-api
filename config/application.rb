# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

ApplicationLoader.load_gems
ApplicationLoader.load_app
ApplicationLoader.load_sidekiq_redis

# Start the application
class AlpopAnalysis < Sinatra::Base
  set :routes, ApplicationController.subclasses.map(&:routes).flatten

  # Load the application routes automatically
  ApplicationController.subclasses.each { |controller| use controller }

  use Rack::Protection # Enable Rack::Protection middleware
end
