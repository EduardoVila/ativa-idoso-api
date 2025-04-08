# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/api/webhook_integrator'
require_relative '../../../app/integrators/errors/api/webhook_response_error'
RSpec.describe Api::WebhookIntegrator do
  let!(:token) { create :guarantor_token }
  let(:webhook_event) do
    create(
      :api_webhook_event,
      callback_url: 'https://example.com/callback',
      payload: { key: 'value' },
      callback_id: '12345'
    )
  end
  let(:response_headers) { { 'Content-Type' => 'application/json' } }
  let(:request_headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Faraday v2.12.2',
      'Content-Type' => 'application/json'
    }
  end

  before do
    WebMock.disable_net_connect!
  end

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:create_resource_call) do
      described_class.new.create_resource(webhook_event)
    end

    context 'when the response is successful' do
      before do
        stub_request(:post, webhook_event.callback_url)
          .with(
            headers: request_headers,
            body: {
              data: {
                webhook_payload: webhook_event.payload,
                callback_id: webhook_event.callback_id
              }
            }.to_json
          ).to_return(status: 200, headers: response_headers)
      end

      it 'updates the event and returns it' do
        create_resource_call
        expect(webhook_event.status).to eq('processed')
        expect(webhook_event.response).to eq(200)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, webhook_event.callback_url)
          .with(headers: request_headers).to_raise(
            Faraday::ForbiddenError.new('Forbidden')
          ).and_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises an Api::WebhookTriggerCommandError' do
        expect do
          create_resource_call
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
          create_resource_call
        end.to raise_error(Faraday::ConnectionFailed)
      end
    end
  end
end
