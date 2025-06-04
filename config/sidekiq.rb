# frozen_string_literal: true

# To checkout configuration of sidekiq in the application, you can use the following snippet:
#
# `Sidekiq.default_configuration`
#
# It should reflect the content of sidekiq.yml file.

require 'sidekiq'
require 'yaml'
require 'erb'

# Load and parse sidekiq.yml using ERB to handle dynamic Ruby content.
sidekiq_config_path = File.expand_path('sidekiq.yml', __dir__)

begin
  raw_config = ERB.new(File.read(sidekiq_config_path)).result

  # Permit commonly used classes when calling safe_load.
  permitted_classes = [Symbol]
  sidekiq_config = YAML.safe_load(
    raw_config,
    permitted_classes: permitted_classes,
    aliases: true,
    symbolize_names: true
  ) || {}
rescue Errno::ENOENT
  warn "Sidekiq configuration file not found: #{sidekiq_config_path}"
  exit 1
rescue Psych::SyntaxError => e
  warn "Sidekiq configuration file contains invalid YAML: #{e.message}"
  exit 1
end

# Fetch Redis URL, fallback to ENV variable or default to localhost.
redis_url = sidekiq_config.fetch(
  :redis_url, ENV.fetch('STACKHERO_REDIS_URL_CLEAR', 'redis://localhost:6379/0')
)

redis_config = { url: redis_url, network_timeout: 5, reconnect_attempts: 3 }

sidekiq_config.tap do |yaml_config|
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      ActiveRecord::Base.establish_connection(Database.fetch_config)
    end
    config.merge!(yaml_config)

    # Configure Redis connection for the server.
    config.redis = redis_config
  end

  Sidekiq.configure_client do |config|
    config.merge!(yaml_config)
    config.redis = redis_config
  end
end
