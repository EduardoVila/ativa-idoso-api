# frozen_string_literal: true

require 'rake'

# Load all .rake files from lib/tasks
begin
  Dir.glob('lib/tasks/**/*.rake').each { |r| import r }
rescue StandardError => e
  puts "Error loading Rake tasks: #{e.message}"
  puts e.backtrace
end
