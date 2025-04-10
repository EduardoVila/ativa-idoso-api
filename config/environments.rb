# frozen_string_literal: true

# This is the environments file that will be used to configure the application

# settings.database.connection.raw_connection.conninfo to get connection info
# settings.database.connection.raw_connection.conninfo[6][:val] to get connection dbname

require 'sinatra' # Load the Sinatra web framework
require 'sinatra/activerecord' # Load the ActiveRecord ORM
require 'dotenv/load' # Load the dotenv gem to read .env files
require 'rack/cors' # Load the Rack::Cors middleware for CORS support
require 'rack/ssl-enforcer' # Load the Rack::SslEnforcer middleware for SSL enforcement
require_relative 'database'

Dotenv.load # Load environment variables from .env files

# To set the environment, use the RACK_ENV environment variable
set :environment, ENV.fetch('RACK_ENV', 'development') # Default to development

# ApplicationLoader module to load the application and its dependencies
module ApplicationLoader
  require 'require_all'
  require 'bundler/setup'

  def self.load_gems(environment = ENV.fetch('RACK_ENV'))
    ENV.fetch('BUNDLE_GEMFILE', File.expand_path('../Gemfile', __dir__))

    Bundler.require(:default, environment.to_sym)
  end

  def self.load_app
    # Load all Ruby files in the app directory

    # Load all models first to ensure constants are available to other classes (e.g. concerns)
    require_relative '../app/models/application_record'

    lib_validators = File.join(File.dirname(__FILE__), '../lib/validators/*.rb')
    require_all lib_validators

    models_dir = File.join(File.dirname(__FILE__), '../app/models/*.rb')
    require_all models_dir

    # Load the rest of the application
    app_dir = File.join(File.dirname(__FILE__), '../app/**/*.rb')
    require_all app_dir
  end

  def self.load_sidekiq_redis
    require_relative 'sidekiq' # Load the Sidekiq configuration
    require_relative 'redis_cache' # Load the Redis cache configuration
  end
end

# Load environment-specific configurations
configure :development do
  set :database, Database.fetch_config
  set :show_exceptions, :after_handler # Enable error reporting
  set :logging, true # Enable logging in development

  configure :development do
    use Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 max_age: 600
      end
    end
  end
end

configure :test do
  set :database, Database.fetch_config
  set :show_exceptions, false # Disable error reporting
end

configure :production do
  set :database, Database.fetch_config
  set :show_exceptions, false # Disable error reporting
  set :logging, true # Enable logging in production
end

configure :development, :test, :production do
  enable :logging
  enable :dump_errors
  enable :raise_errors

  set :server, :puma # Use the Puma web server
  set :app_file, File.expand_path('application.rb', __dir__) # Set the application file
  set :root, File.expand_path('../alpop-analysis', __dir__) # Set the root directory
  set :public_folder, File.expand_path('public', __dir__) # Set the public directory
  set :time_zone,
      Time.zone_default = ActiveSupport::TimeZone['America/Sao_Paulo']

  # Setting the default locale to Brazilian Portuguese
  I18n.load_path += Dir[
    File.join(
      File.expand_path('..', __dir__), 'config', 'locales', '**', '*.{rb,yml}'
    )
  ]
  I18n.default_locale = :'pt-BR'

  use Rack::Cors do
    allow do
      origins ENV.fetch('CORS_ALLOWED_ORIGINS', 'alpop.com.br')
      resource '*',
               headers: :any,
               methods: %i[get post put patch delete options head],
               expose: %w[Authorization],
               max_age: 600
    end
  end
end
