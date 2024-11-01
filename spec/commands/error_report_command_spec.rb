# require 'sentry-ruby'
# require 'rspec'
# # require 'mocha/api'

# def sentry_dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0'

# RSpec.describe 'Sentry Configuration' do
#   before do
#     ENV['SENTRY_DSN'] = sentry_dsn
#   end

#   it 'configures Sentry with the correct DSN' do

#     Sentry.init do |config|
#       config.enabled_environments = %w[production]
#       config.dsn = ENV.fetch('SENTRY_DSN')
#       config.breadcrumbs_logger = %i[active_support_logger http_logger]
#       config.traces_sample_rate = 0.5
#     end

#     config = Sentry.configuration

#     expect(config.enabled_environments).to eq(%w[production])
#     expect(config.dsn.as_json['raw_value']).to eq(sentry_dsn)
#     expect(config.breadcrumbs_logger).to eq(%i[active_support_logger
#                                                http_logger])
#     expect(config.traces_sample_rate).to eq(0.5)
#   end

#   it 'raises an error if SENTRY_DSN is not set' do
#     ENV.delete('SENTRY_DSN')

#     expect do
#       Sentry.init do |config|
#         config.enabled_environments = %w[production]
#         config.dsn = ENV.fetch('SENTRY_DSN')
#         config.breadcrumbs_logger = %i[active_support_logger http_logger]
#         config.traces_sample_rate = 0.5
#       end
#     end.to raise_error(KeyError)
#   end

#   it 'does not enable Sentry in non-production environments' do
#     Sentry.init do |config|
#       config.enabled_environments = %w[production]
#       config.dsn = ENV.fetch('SENTRY_DSN')
#       config.breadcrumbs_logger = %i[active_support_logger http_logger]
#       config.traces_sample_rate = 0.5
#     end

#     config = Sentry.configuration

#     expect(config.enabled_environments).not_to include('development')
#     expect(config.enabled_environments).not_to include('test')
#   end
# end
