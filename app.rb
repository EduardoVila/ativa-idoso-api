# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'require_all'
require 'dotenv/load' # Load environment variables from .env file

# Load all files in the app directory
class App < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'

    register Sinatra::Reloader
    also_reload 'app/**/*.rb'

    enable :logging
  end

  # Add your routes here, for example:
  get '/' do
    'Hello, Sinatra!'
  end

  # Initialize your router if you have one
  Router.init(self) if defined?(Router)
end

# Start the application
run App if __FILE__ == $PROGRAM_NAME
