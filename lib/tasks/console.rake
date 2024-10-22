# frozen_string_literal: true

desc 'Alias for console:start'
task console: 'console:start'

desc 'Alias for console:start'
task c: 'console:start'

# Define a task to start the Pry console
namespace :console do
  desc 'Start the Pry console'
  task :start do
    require_relative '../../config/environments'

    load_gems

    require_all File.join(File.dirname(__FILE__), '../../app')

    connect_database

    # Start the Pry console
    binding.pry
  end
end
