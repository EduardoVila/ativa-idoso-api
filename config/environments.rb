# frozen_string_literal: true

# settings.database.connection.raw_connection.conninfo to get connection info
# settings.database.connection.raw_connection.conninfo[6][:val] to get connection dbname

require 'sinatra' # Load the Sinatra web framework
require 'sinatra/activerecord' # Load the ActiveRecord ORM
require 'dotenv/load' # Load the dotenv gem to read .env files

Dotenv.load # Load environment variables from .env files

# To set the environment, use the APP_ENV environment variable
set :environment, ENV.fetch('APP_ENV', 'development') # Default to development
set :server, :puma # Use the Puma web server
set :app_file, File.expand_path('application.rb', __dir__) # Set the application file
set :root, File.expand_path('../alpop-analysis', __dir__) # Set the root directory

# Set the database configuration
db_config = {
  adapter: 'postgresql',
  encoding: 'unicode',
  username: ENV.fetch('DB_USER'),
  password: ENV.fetch('DB_PASSWORD'),
  host: ENV.fetch('DB_HOST'),
  port: ENV.fetch('DB_PORT'),
  pool: ENV.fetch('DB_POOL_SIZE'),
  timeout: ENV.fetch('DB_TIMEOUT')
}

# Load environment-specific configurations
configure :development do
  set :database, db_config.merge(database: ENV.fetch('DB_DEVELOPMENT'))
  set :show_exceptions, :after_handler # Enable error reporting
  set :logging, true # Enable logging in development
end

configure :test do
  set :database, db_config.merge(database: ENV.fetch('DB_TEST'))
  set :show_exceptions, false # Disable error reporting
end

configure :production do
  set :database, db_config.merge(database: ENV.fetch('DB_PRODUCTION'))
  set :show_exceptions, false # Disable error reporting
  set :logging, true # Enable logging in production
end

# Implement a loader to load the application and its dependencies
module ApplicationLoader
  def self.load_gems(environment = ENV.fetch('APP_ENV'))
    require 'bundler/setup'

    ENV.fetch('BUNDLE_GEMFILE', File.expand_path('../Gemfile', __dir__))

    Bundler.require(:default, environment.to_sym)
  end

  def self.load_app
    require 'require_all'

    app_dir = File.join(File.dirname(__FILE__), '../app')

    # Require all other files
    require_all app_dir
  end
end
