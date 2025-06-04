# frozen_string_literal: true

require 'sentry-ruby'
require 'sentry-sidekiq'

Sentry.init do |config|
  config.environment = ENV.fetch('RACK_ENV', 'development')
  config.enabled_environments = %w[production]
  config.dsn = ENV.fetch('SENTRY_DSN')
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.traces_sample_rate = 0.5
end
