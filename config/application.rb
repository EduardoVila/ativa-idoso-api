# frozen_string_literal: true

# This is the main application file that will be used to start the application

# Load the application loader and environments
require_relative 'environments'
# Load gems according to the environment
ApplicationLoader.load_gems

# Load the application and lib directories
ApplicationLoader.load_app
ApplicationLoader.load_lib

require_relative 'router'

# Start the application
class AlpopAnalysis < Sinatra::Base
  configure :development, :test, :production do
    enable :logging
    enable :dump_errors
    enable :raise_errors
  end

  Router.init(self)
end
