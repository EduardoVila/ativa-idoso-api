# frozen_string_literal: true

# Source for the gems
source 'https://rubygems.org'

# Ruby version
ruby '3.3.5'

# Core Gems
gem 'activejob', '~> 8' # Background job processing
gem 'activemodel', '~> 8' # Model framework for ActiveRecord
gem 'active_model_serializers' # JSON serialization for models
gem 'activerecord', '~> 8' # ORM for database interaction
gem 'activesupport', '~> 8' # Utility classes and extensions
gem 'bcrypt' # Password hashing
gem 'bullet' # N+1 query detection
gem 'colorize' # Colorized output
gem 'cpf_cnpj' # CPF and CNPJ validation
gem 'damerau-levenshtein' # Damerau-Levenshtein distance calculation
gem 'dotenv' # Environment variable management
gem 'faraday' # HTTP client for making API requests
gem 'faraday-net_http' # Net::HTTP adapter for Faraday
gem 'faraday-retry' # Retry middleware for Faraday
gem 'fiddle'
gem 'foreman' # Process manager for running multiple processes
gem 'i18n' # Internationalization support
gem 'jwt' # JSON Web Token support
gem 'ostruct' # OpenStruct for storing data
gem 'paper_trail' # Versioning for records
gem 'pg' # PostgreSQL database adapter
gem 'pry' # REPL for debugging
gem 'pry-byebug' # Enhanced REPL for debugging
gem 'pry-coolline' # CoolLine integration for Pry
gem 'puma' # Web server for serving the application
gem 'rack-attack' # Rack middleware for blocking requests
gem 'rake' # Task runner for the application
gem 'redis' # Redis client for caching
gem 'require_all' # Require all files in a directory
gem 'sentry-ruby'
gem 'sidekiq' # Background job processing
gem 'sidekiq-batch' # Batch processing for Sidekiq
gem 'sidekiq-status' # Status tracking for Sidekiq jobs
gem 'sinatra' # Core framework for the application
gem 'sinatra-activerecord' # ActiveRecord integration with Sinatra
gem 'sinatra-contrib' # Additional Sinatra utilities
gem 'tzinfo' # Timezone support
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :development, :test do
  gem 'byebug' # Debugger for debugging
  gem 'capybara' # Acceptance testing framework
  gem 'clipboard' # Copy to clipboard functionality in tests
  gem 'cpf_faker' # CPF generation for tests
  gem 'database_cleaner-active_record' # Ensures a clean state for tests
  gem 'factory_bot' # Fixtures replacement for tests
  gem 'faker' # Data generation for tests
  gem 'guard' # Automatic test running
  gem 'guard-rspec', require: false # Integration with RSpec
  gem 'rack-test' # Helpers for testing Rack applications
  gem 'rspec' # Testing framework
  gem 'shoulda-matchers' # Matchers for common Rails functionality
  gem 'simplecov' # Code coverage reporting
  gem 'simplecov-lcov', require: 'simplecov' # Lcov output for coverage reports
  gem 'sinatra-reloader', require: 'sinatra/reloader' # Reloading during development
  gem 'webmock' # Stubbing HTTP requests in tests
end

group :development do
  # Development and Debugging Gems
  gem 'annotaterb' # Adds comments to models with schema information
  gem 'database_consistency', require: false # Database consistency checks
  gem 'rubocop' # Code analyzer and formatter
  gem 'rubocop-capybara' # Capybara-specific RuboCop rules
  gem 'rubocop-factory_bot' # FactoryBot-specific RuboCop rules
  gem 'rubocop-performance' # Performance optimizations for RuboCop
  gem 'rubocop-rake' # RuboCop tasks for Rake
  gem 'rubocop-rspec' # RSpec-specific RuboCop rules
end
