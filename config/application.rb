# frozen_string_literal: true

# Load the application loader and environments
require_relative 'environments'
require_relative 'router'

# Add the lib directory to the load path
$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

# Load gems and the application
ApplicationLoader.load_gems
ApplicationLoader.load_app

# Start the application
class AlpopAnalysis < Sinatra::Base
  configure :development, :test, :production do
    enable :logging
    enable :dump_errors
    enable :raise_errors
  end

  Router.init(self)
end
