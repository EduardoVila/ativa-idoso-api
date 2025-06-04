# frozen_string_literal: true

namespace :sentry do
  desc 'Test Sentry integration in production environment'
  task :test do
    if ENV.fetch('RACK_ENV') == 'production'
      require_relative '../../config/sentry' # Ensure Sentry is configured
      puts 'Running Sentry test in production environment...'
      SentryTest.run
    else
      puts 'Skipping Sentry test. This task should only be run in production.'
    end
  end
end

class SentryTest
  def self.run
    puts 'Testing Sentry integration...'

    # Test exception capture
    begin
      1 / 0
    rescue ZeroDivisionError => e
      Sentry.capture_exception(e)
      puts '✓ Exception captured and sent to Sentry'
    end

    # Test message capture
    Sentry.capture_message('Test message')
    puts '✓ Message captured and sent to Sentry'

    puts 'Sentry test completed. Check your Sentry dashboard for events.'
  end
end
