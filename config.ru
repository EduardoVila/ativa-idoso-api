# frozen_string_literal: true

# The config.ru file is used to configure Rack-based web applications.
# This file is used to start up the application when running the command
# `puma` (http://localhost:3000/), or `rackup` (http://localhost:9292/)
# or `foreman start` (http://localhost:5000/).

require_relative 'config/application' # Load your main application file

run AlpopAnalysis # Run the Sinatra application
