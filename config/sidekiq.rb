# frozen_string_literal: true

require 'sidekiq'
require 'yaml'

sidekiq_config = YAML.load_file(File.join(__dir__, 'sidekiq.yml'))

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', sidekiq_config['redis_url']) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', sidekiq_config['redis_url']) }
end
