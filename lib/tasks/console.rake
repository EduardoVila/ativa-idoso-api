# frozen_string_literal: true

desc 'Short alias for console:start'
task console: 'console:start'

desc 'Shortest alias for console:start'
task c: 'console:start'

# Define a task to start the Pry console
namespace :console do
  desc 'Start the Pry console'
  task :start do
    require_relative '../../config/environments' # Environment setup
    require_relative '../../config/application' # Application setup
    # require_relative '../../spec/spec_helper' # RSpec setup
    Dir[File.join(__dir__, '../../spec/factories/**/*.rb')].each { |file| require file } # FactoryBot setup
    binding.pry # rubocop:disable Lint/Debugger
  end
end
