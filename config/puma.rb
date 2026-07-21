# frozen_string_literal: true

require 'dotenv'
Dotenv.load

environment_name = ENV.fetch('RACK_ENV', 'development')

threads_count = Integer(ENV.fetch('MAX_THREADS', 5))
threads threads_count, threads_count

port_number = ENV.fetch('PORT', 3001)
port port_number

puts "Starting Puma on port #{port_number}"

environment environment_name

if environment_name == 'production'
  workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
  preload_app!

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end
