# frozen_string_literal: true

# This is the environments file that will be used to configure the application

require 'sinatra' # Load the Sinatra web framework
require 'sinatra/activerecord' # Load the ActiveRecord ORM
require 'dotenv/load' # Load the dotenv gem to read .env files
require 'rack/cors' # Load the Rack::Cors middleware for CORS support
require 'rack/ssl-enforcer' # Load the Rack::SslEnforcer middleware for SSL enforcement

Dotenv.load # Load environment variables from .env files

module EnvHelper
  def self.fetch(name, default = nil)
    value = ENV.fetch(name, default)
    return value unless value.is_a?(String)

    # Convert hex escape sequences to their character representations
    value.gsub(/\\x([0-9a-fA-F]{2})/) do # Regexp to match hex escape sequences
      # Convert the hex value to an integer and then to a character
      [::Regexp.last_match(1).to_i(16)].pack('C')
    end
  end
end

set :database_file, 'database.yml'

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

    models_dir = File.join(File.dirname(__FILE__), '../app/models/*.rb')
    require_all models_dir

    # Load the rest of the application
    app_dir = File.join(File.dirname(__FILE__), '../app/**/*.rb')
    require_all app_dir
  end

  def self.load_sidekiq
    require_relative 'sidekiq' # Load the Sidekiq configuration
  end

  def self.load_redis_cache
    require_relative 'redis_cache' # Load the Redis cache configuration
  end

  def self.load_sentry
    require_relative 'sentry' # Load the Sentry configuration
  end
end

# Load environment-specific configurations
configure :development do
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
  set :show_exceptions, false # Disable error reporting
end

configure :production do
  set :show_exceptions, false # Disable error reporting
  set :logging, true # Enable logging in production

  # use Rack::SslEnforcer, hsts: { subdomains: true }, only_https: true
end

configure :development, :test, :production do
  enable :logging
  enable :dump_errors
  enable :raise_errors

  set :server, :puma
  set :app_file, File.expand_path('application.rb', __dir__)
  set :root, File.expand_path('../alpop-analysis', __dir__)
  set :public_folder, File.expand_path('public', __dir__)
  set :time_zone,
      Time.zone_default = ActiveSupport::TimeZone['America/Sao_Paulo']

  # Setting the default locale to Brazilian Portuguese
  I18n.load_path += Dir[
    File.join(
      File.expand_path('..', __dir__), 'config', 'locales', '**', '*.{rb,yml}'
    )
  ]
  I18n.default_locale = :'pt-BR'

  set :orm, ActiveRecord::Base # Set the ORM to ActiveRecord
  if settings.environment == :development
    ActiveRecord::Base.logger =
      Logger.new($stdout)
  end

  # Enable ActiveRecord encryption
  ActiveRecord::Encryption.config.primary_key =
    EnvHelper.fetch('ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY')
  ActiveRecord::Encryption.config.deterministic_key =
    EnvHelper.fetch('ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY')
  ActiveRecord::Encryption.config.key_derivation_salt =
    EnvHelper.fetch('ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT')

  use Rack::Protection
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
