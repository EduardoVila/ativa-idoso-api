# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
require 'simplecov-lcov'
require_relative '../config/environments'
require_relative '../config/application'

connect_database
load_gems
load_app

Dotenv.load

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::LcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
])
SimpleCov.minimum_coverage 98
SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Serializers', 'app/serializers'
  add_group 'Integrators', 'lib/integrators'
  add_group 'Services', 'app/services'

  add_filter 'app/models/application_record.rb'
  add_filter 'config'
  add_filter 'app/serializers/application_serializer.rb'
  add_filter 'app/models/concerns'
  add_filter 'lib/concerns'
  add_filter 'app'
end

# Gera o relatório de cobertura ao finalizar os testes
SimpleCov.at_exit { SimpleCov.result.format! }

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  # Configurar FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Configurar shoulda-matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
      with.library :action_controller
    end
  end

  config.before(:suite) do
    FactoryBot.find_definitions

    ActiveRecord::Migration.migrate('db/migrate')
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
