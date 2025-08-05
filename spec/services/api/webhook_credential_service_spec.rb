# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::WebhookCredentialService do
  let(:webhook_credential) { instance_double(Api::WebhookCredential, id: 1) }
  let(:integrator_instance) do
    instance_double(Api::WebhookCredentialIntegrator)
  end
  let(:integrator_class) do
    class_double(Api::WebhookCredentialIntegrator).as_stubbed_const
  end
  let(:default_ttl) { Api::WebhookCredentialService::DEFAULT_TOKEN_TTL }

  let(:service) { described_class.new(integrator_class) }
  let(:token_data) do
    { access_token: 'foo1', expires_in: 3600, expires_at: Time.now.to_i + 3600 }
  end
  let(:cache_key) { "webhook_token:#{webhook_credential.id}" }

  before do
    allow(integrator_class).to receive(:new).and_return(integrator_instance)
    allow(integrator_instance).to receive(:create_resource)
      .with(webhook_credential).and_return(token_data)
    allow(RedisCache).to receive(:get).and_return(nil)
    allow(RedisCache).to receive(:set)
  end

  describe '#call' do
    context 'when webhook_credential is nil' do
      it 'returns nil' do
        expect(service.call(nil)).to be_nil
      end
    end

    context 'when token is cached and not expired' do
      before do
        allow(RedisCache).to receive(:get).with(cache_key)
          .and_return(token_data)
        allow(service).to receive(:expired?)
          .and_return(false)
      end

      it 'returns the cached token' do
        expect(service.call(webhook_credential)).to eq('foo1')
      end
    end

    context 'when token is not cached or expired' do
      before do
        allow(RedisCache).to receive(:get).with(cache_key).and_return(nil)
      end

      it 'requests a new token and caches it' do
        expect(service.call(webhook_credential)).to eq('foo1')

        expect(RedisCache).to have_received(:set).with(
          cache_key,
          token_data,
          ttl: token_data[:expires_in] || default_ttl
        )
      end
    end
  end
end
