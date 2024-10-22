# frozen_string_literal: true

require_relative 'environments'

load_gems(ENV.fetch('ENVIRONMENT'))
connect_database
load_app

# Start the application
class AlpopAnalysis < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    enable :logging
  end

  # Add your routes here, for example:
  get '/' do
    'Hello, AlpopAnalysis!'
  end

  # Initialize your router if you have one
  Router.init(self) if defined?(Router)
end

# Start the application
run AlpopAnalysis if __FILE__ == $PROGRAM_NAME
