# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require_relative '../integrable'
require_relative '../../../app/integrators/api/webhook_credential_integrator'

RSpec.describe Api::WebhookCredentialIntegrator do
  let(:webhook_credential) do
    create(
      :api_webhook_credential,
      client_id: 'test-client-id',
      client_secret: 'test-client-secret',
      auth_url: 'https://external.example.com/token'
    )
  end
  let(:response_headers) { { 'Content-Type' => 'application/json' } }
  let(:request_headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Faraday v2.13.1',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Basic #{enc64}",
      'X-Idempotency-Key' => /.*/
    }
  end
  let(:enc64) do
    Base64.strict_encode64(
      "#{webhook_credential.client_id}:#{webhook_credential.client_secret}"
    )
  end
  let(:request_body) { { grant_type: 'client_credentials' } }
  let(:response_body) do
    {
      access_token: 'abc123',
      expires_in: 1800
    }.to_json
  end

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:integrator) { described_class.new }

    context 'when webhook_credential is nil' do
      it 'returns nil' do
        expect(integrator.create_resource(nil)).to be_nil
      end
    end

    context 'when Faraday::Error is raised' do
      before do
        allow(ErrorLogger).to receive(:log)
        stub_request(:post, webhook_credential.auth_url)
          .with(headers: request_headers)
          .to_raise(Faraday::Error.new('Connection failed'))
      end

      it 'logs and raises the error' do
        expect { integrator.create_resource(webhook_credential) }
          .to raise_error(Faraday::Error)

        expect(ErrorLogger).to have_received(:log)
          .with(instance_of(Faraday::Error))
      end
    end

    context 'when webhook_credential is present and response is valid' do
      before do
        stub_request(:post, webhook_credential.auth_url)
          .with(headers: request_headers, body: request_body)
          .to_return(
            status: 200, body: response_body, headers: response_headers
          )
      end

      it 'returns a hash with access_token, expires_in, and expires_at' do
        result = integrator.create_resource(webhook_credential)
        expect(result[:access_token]).to eq('abc123')
        expect(result[:expires_in]).to eq(1800)
        expect(result[:expires_at]).to be_within(2).of(Time.now.to_i + 1800)
      end
    end
  end
end
