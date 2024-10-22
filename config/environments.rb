# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv/load'

Dotenv.load

# Load environment-specific configurations
configure :development do
  set :database, {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: ENV.fetch('DEVELOPMENT_DB_URL', nil),
    username: ENV.fetch('DB_USER', nil),
    password: ENV.fetch('DB_PASSWORD', nil),
    host: ENV.fetch('DB_HOST', 'localhost'),
    port: ENV.fetch('DB_PORT', 5432),
    pool: ENV.fetch('POOL_SIZE', 5),
    timeout: ENV.fetch('TIMEOUT', 5000)
  }
  set :show_exceptions, true # Enable error reporting
end

configure :test do
  set :database, { adapter: 'postgresql', database: ENV.fetch('TEST_DB_URL', nil) }
  set :show_exceptions, false # Disable error reporting
end

configure :production do
  set :database, { adapter: 'postgresql', database: ENV.fetch('PRODUCTION_DB_URL', nil) }
  set :show_exceptions, false # Disable error reporting
  set :logging, true # Enable logging in production
end

# Common settings for all environments
set :sessions, true
set :session_secret, ENV['SESSION_SECRET'] || ''

def load_gems(environment = ENV.fetch('ENVIRONMENT', 'development'))
  require 'bundler/setup'

  ENV.fetch('BUNDLE_GEMFILE', File.expand_path('../Gemfile', __dir__))

  Bundler.require(:default, environment.to_sym)
end

def connect_database(environment = ENV.fetch('ENVIRONMENT', 'development'))
  settings.database.establish_connection(environment.to_sym)
end
