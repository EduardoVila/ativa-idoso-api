# frozen_string_literal: true

# Define a task to start the Pry console
namespace :console do
  desc 'Start the Pry console'
  task :start do
    require 'bundler/setup' # Set up Bundler to load the default gems
    require 'dotenv/load'   # Load environment variables

    # Set up Bundler based on the environment
    environment = ENV.fetch('ENVIRONMENT', 'development')

    # Require the main application file
    require_relative '../../app'

    # Load the appropriate groups based on the environment
    Bundler.require(:default, environment.to_sym)

    # Start the Pry console
    binding.pry # rubocop:disable Lint/Debugger
  end
end
