# frozen_string_literal: true

# Configure ActiveJob to use Sidekiq
require 'active_job'
require 'sidekiq'

ActiveJob::Base.queue_adapter = :sidekiq

class ApplicationJob < ActiveJob::Base
end
