# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

# Set up SimpleCov - must be done before requiring any of the application code
require 'simplecov'
require 'simplecov-lcov'

SimpleCov.start do
  add_group 'Commands', 'app/commands'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Integrators', 'app/integrators'
  add_group 'Data Loaders', 'app/data_loaders'
  add_group 'Serializers', 'app/serializers'

  add_filter 'config'
  add_filter 'lib/concerns'

  add_filter 'app/models/application_record.rb'
  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/commands/application_command.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/services/application_service.rb'
  add_filter 'app/integrators/application_integrator.rb'
  add_filter 'app/serializers/application_serializer.rb'

  add_filter 'app/models/concerns'
  add_filter 'app/controllers/concerns'

  add_filter 'app/core_extensions'

  add_filter 'spec/helpers'
end

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::LcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
])

SimpleCov.at_exit do
  SimpleCov.result.format!
  SimpleCov.minimum_coverage 98
end

# Loading the application code after SimpleCov is set up
require_relative '../config/application'
require_relative 'helpers/serializers/serialize_attribute'
require_relative 'helpers/serializers/match_serialized_records'
require 'active_support/testing/assertions'

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
    ActiveJob::Base.queue_adapter = :test
  end

  config.before do
    DatabaseCleaner.start
  end

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
  config.include ActiveSupport::Testing::Assertions

  # Serializers config
  config.include MatchSerializerRecordSupportMatcher
  config.include SerializeAttributeSupportMatcher, type: :serializer
  config.define_derived_metadata(file_path: %r{/spec/serializers}) do |metadata|
    metadata[:type] = :serializer
  end

  # Auditable config (concern) - checks if the model is auditable
  RSpec::Matchers.define :be_auditable do
    match do |actual|
      expect(Auditable.models).to include actual.class
    end
  end
end
