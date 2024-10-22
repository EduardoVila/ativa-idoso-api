# frozen_string_literal: true

require 'rake'
require 'sinatra/activerecord/rake'
require_relative 'config/environments' # Load settings

# Load all .rake files from lib/tasks
begin
  connect_database
  Dir.glob('lib/tasks/**/*.rake').each { |r| import r }
rescue StandardError => e
  puts "Error loading Rake tasks: #{e.message}"
  puts e.backtrace
end
