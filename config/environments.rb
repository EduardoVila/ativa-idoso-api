# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv/load'

Dotenv.load

ENV['ENVIRONMENT'] ||= 'development'

# Load environment-specific configurations
configure :development do
  set :database, { adapter: 'postgresql', database: ENV['DEV_DATABASE_URL'] }
  set :show_exceptions, true # Enable error reporting
end

configure :test do
  set :database, { adapter: 'postgresql', database: ENV['TEST_DATABASE_URL'] }
  set :show_exceptions, false # Disable error reporting
end

configure :production do
  set :database, { adapter: 'postgresql', database: ENV['PROD_DATABASE_URL'] }
  set :show_exceptions, false # Disable error reporting
  set :logging, true # Enable logging in production
end

# Common settings for all environments
set :sessions, true
set :session_secret, ENV['SESSION_SECRET'] || 'your_secret_key'
set :public_folder, "#{File.dirname(__FILE__)}/public"
set :views, "#{File.dirname(__FILE__)}/views"
