# Source for the gems
source 'https://rubygems.org'

# Ruby version
ruby '3.3.5'

# Core Gems
gem 'sinatra'                    # Core framework for the application
gem 'rake'                       # Task runner for the application
gem 'pg'                         # PostgreSQL database adapter
gem 'devise'                     # User authentication
gem 'activerecord'               # ORM for database interaction
gem 'activerecord-import'        # Bulk import for ActiveRecord
gem 'activejob'                  # Background job processing
gem 'activesupport'              # Utility classes and extensions
gem 'jbuilder'                   # JSON builder for views
gem 'sinatra-activerecord'       # ActiveRecord integration with Sinatra
gem 'puma'                       # Web server for serving the application
gem 'dotenv'                     # Environment variable management
gem 'faraday'                    # HTTP client for making API requests
gem 'sinatra-contrib'            # Additional Sinatra utilities
gem 'bullet'                     # N+1 query detection
gem "foreman"                    # Process manager for running multiple processes
gem 'redis'                      # Redis client for caching
gem 'sidekiq'                    # Background job processing
gem 'sidekiq-batch'              # Batch processing for Sidekiq
gem 'sidekiq-status'             # Status tracking for Sidekiq jobs
gem 'require_all'                # Require all files in a directory
gem 'i18n'                       # Internationalization support
gem 'tzinfo'                     # Timezone support

group :development, :test do
  # Development and Debugging Gems
  gem 'pry-byebug'                 # Enhanced REPL for debugging
  gem 'annotate'                   # Adds comments to models with schema info
  gem 'rubocop'                    # Code analyzer and formatter
  gem 'rubocop-performance'        # Performance optimizations for RuboCop
  gem 'rubocop-capybara'           # Capybara-specific RuboCop rules
  gem 'rubocop-factory_bot'        # FactoryBot-specific RuboCop rules
  gem 'database_consistency', require: false # Database consistency checks

  # Testing Frameworks
  gem 'rspec'                      # Testing framework
  gem 'capybara'                   # Acceptance testing framework
  gem 'guard'                      # Automatic test running
  gem 'guard-rspec', require: false # Integration with RSpec
  gem 'simplecov'                  # Code coverage reporting
  gem 'simplecov-lcov'             # Lcov output for coverage reports
  gem 'faker'                      # Data generation for tests
  gem 'shoulda-matchers'           # Matchers for common Rails functionality
  gem 'factory_bot'                # Fixtures replacement for tests
  gem 'database_cleaner-active_record' # Ensures a clean state for tests
  gem 'webmock'                    # Stubbing HTTP requests in tests
  gem 'rack-test'                  # Helpers for testing Rack applications
  gem 'clipboard'                  # Copy to clipboard functionality in tests
  gem 'sinatra-reloader', require: 'sinatra/reloader' # Reloading during development
  gem 'spring'                     # Preloads application for faster boot times
  gem 'spring-watcher-listen'      # Watches files for changes in Spring
end
