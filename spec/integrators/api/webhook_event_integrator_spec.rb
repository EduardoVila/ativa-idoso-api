# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/api/webhook_event_integrator'
require_relative '../../../app/integrators/errors/api/webhook_response_error'

RSpec.describe Api::WebhookEventIntegrator do
  let(:credential_service) { Api::WebhookCredentialService }
  let(:webhook_event) do
    create(
      :api_webhook_event,
      callback_url: 'https://example.com/callback',
      payload: { key: 'value' },
      callback_id: '12345'
    )
  end
  let(:webhook_credential) { create :api_webhook_credential }
  let(:response_headers) { { 'Content-Type' => 'application/json' } }
  let(:request_headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Faraday v2.13.1',
      'Content-Type' => 'application/json'
    }
  end

  before do
    WebMock.disable_net_connect!

    allow(credential_service).to receive(:new).and_return(
      instance_double(credential_service, call: 'mocked_access_token')
    )
  end

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:integrator) { described_class.new }

    let(:request_body) do
      {
        data: {
          webhook_payload: webhook_event.payload,
          callback_id: webhook_event.callback_id
        }
      }.to_json
    end

    context 'when webhook_event or webhook_credential is blank' do
      it 'returns nil if webhook_event is blank' do
        expect(integrator.create_resource(nil, webhook_credential)).to be_nil
      end

      it 'returns nil if webhook_credential is blank' do
        expect(integrator.create_resource(webhook_event, nil)).to be_nil
      end
    end

    context 'when the response is successful' do
      before do
        stub_request(:post, webhook_event.callback_url)
          .with(headers: request_headers, body: request_body)
          .to_return(status: 200, headers: response_headers)
      end

      it 'updates the event and returns it' do
        integrator.create_resource(webhook_event, webhook_credential)

        expect(webhook_event.status).to eq('processed')
        expect(webhook_event.response).to eq(200)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, webhook_event.callback_url)
          .with(headers: request_headers)
          .to_raise(Faraday::ForbiddenError.new('Forbidden'))
          .and_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises an Api::WebhookTriggerCommandError' do
        expect do
          integrator.create_resource(webhook_event, webhook_credential)
        end.to raise_error(Faraday::ForbiddenError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, webhook_event.callback_url)
          .with(headers: request_headers)
          .to_raise(Faraday::ConnectionFailed.new('Connection failed'))
          .and_return(
            status: 500,
            body: nil,
            headers: response_headers
          )
      end

      it 'raises a Faraday::ConnectionFailed' do
        expect do
          integrator.create_resource(webhook_event, webhook_credential)
        end.to raise_error(Faraday::ConnectionFailed)
      end
    end
  end
end
