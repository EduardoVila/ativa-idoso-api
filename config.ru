# frozen_string_literal: true

# The config.ru file is used to configure Rack-based web applications.
# This file is used to start up the application when running the command
# `puma` (http://localhost:3000/), or `rackup` (http://localhost:9292/)
# or `foreman start` (http://localhost:5000/).
#
# The following code snippet is used to mount the Sidekiq web interface
# to the main Sinatra application. This allows you to monitor the Sidekiq
# jobs. The Sidekiq web interface is mounted at the /sidekiq path.
# More info in:
# https://stackoverflow.com/questions/29043115/how-can-i-use-sidekiq-monitoring-with-a-sinatra-app
#
require_relative 'config/application' # Load your main application file
require 'sidekiq/web'

run Rack::URLMap.new('/' => AlpopAnalysis, '/sidekiq' => Sidekiq::Web) # Run the Sinatra application
