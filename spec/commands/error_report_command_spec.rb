# frozen_string_literal: true

require 'sentry-ruby'
require 'rspec'
require_relative '../../app/commands/error_report_command'

RSpec.describe ErrorReportCommand do
  let(:error_message) { 'Test error message' }
  let(:error) { StandardError.new(error_message) }
  let(:command) { described_class.new(error) }
  let(:sentry_dsn) { 'https://examplePublicKey@o0.ingest.sentry.io/0' }
  let(:sentry_double) do
    class_double(Sentry, capture_message: nil).as_stubbed_const
  end

  before { Sentry.init { |config| config.dsn = sentry_dsn } }

  describe '#initialize' do
    it 'assigns the error to @err' do
      expect(command.err).to eq(error)
    end
  end

  describe '#call' do
    before { allow(Sentry).to receive(:capture_message).with(error) }

    it 'reports the error to Sentry' do
      command.call
      sleep 0.1 # Give the thread some time to execute
      expect(Sentry).to have_received(:capture_message).with(error)
    end
  end

  describe 'Sentry Configuration' do
    let(:sentry_config) { Sentry.configuration }

    before { ENV['SENTRY_DSN'] = sentry_dsn }

    it 'configures Sentry with the correct DSN' do
      Sentry.init do |config|
        config.enabled_environments = %w[production]
        config.dsn = sentry_dsn
        config.breadcrumbs_logger = %i[active_support_logger http_logger]
        config.traces_sample_rate = 0.5
      end
      expect(sentry_config.enabled_environments).to eq(%w[production])
      expect(sentry_config.dsn.as_json['raw_value']).to eq(sentry_dsn)
      expect(sentry_config.breadcrumbs_logger).to eq(%i[active_support_logger
                                                        http_logger])
      expect(sentry_config.traces_sample_rate).to eq(0.5)
    end

    it 'raises an error if SENTRY_DSN is not set' do
      ENV.delete('SENTRY_DSN')
      expect do
        Sentry.init do |config|
          config.enabled_environments = %w[production]
          config.dsn = ENV.fetch('SENTRY_DSN')
          config.breadcrumbs_logger = %i[active_support_logger
                                         http_logger]
          config.traces_sample_rate = 0.5
        end
      end.to raise_error(KeyError)
    end

    it 'does not enable Sentry in non-production environments' do
      Sentry.init do |config|
        config.enabled_environments = %w[production]
        config.dsn = ENV.fetch('SENTRY_DSN')
        config.breadcrumbs_logger = %i[active_support_logger http_logger]
        config.traces_sample_rate = 0.5
      end
      expect(sentry_config.enabled_environments).not_to include('development')
      expect(sentry_config.enabled_environments).not_to include('test')
    end
  end
end
