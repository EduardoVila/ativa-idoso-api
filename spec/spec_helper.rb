# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
require 'simplecov-lcov'
require_relative '../config/application'
require_relative 'helpers/serializers/serialize_attribute'
require_relative 'helpers/serializers/match_serialized_records'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::LcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
])

SimpleCov.start do
  add_group 'Commands', 'app/commands'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'

  add_filter '/config'
  add_filter '/lib/concerns'
  add_filter '/app/models/application_record.rb'
  add_filter '/app/models/concerns'
  add_filter '/app/serializers/application_serializer.rb'
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  SimpleCov.minimum_coverage 98
end

module RSpecMixin
  include Rack::Test::Methods

  def application
    Sinatra::Application
  end

  def settings
    application.settings
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryBot::Syntax::Methods

  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
      with.library :action_controller
    end
  end

  config.before(:suite) do
    system('APP_ENV=test bundle exec rake db:restart_test')
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before { DatabaseCleaner.start }
  config.after { DatabaseCleaner.clean }

  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.disable_monkey_patching!
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }

  Kernel.srand config.seed

  # Controller config
  config.include(
    Module.new do
      def app
        described_class
      end
    end,
    type: :controller
  )

  # Job config
  config.include ActiveJob::TestHelper, type: :job

  # Serializers config
  config.include MatchSerializerRecordSupportMatcher
  config.include SerializeAttributeSupportMatcher, type: :serializer
  config.define_derived_metadata(file_path: %r{/spec/serializers}) do |metadata|
    metadata[:type] = :serializer
  end
end

RSpec.configure do |config|
  config.include(
    Module.new do
      def app
        described_class
      end
    end,
    type: :controller
  )
end
