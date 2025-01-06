# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/analysis/token_integrator'
# rubocop: disable Layout/LineLength
require_relative '../../../app/integrators/errors/analysis/token_post_response_error'
# rubocop: enable Layout/LineLength

RSpec.describe Analysis::TokenIntegrator do
  let(:url) { "#{ENV.fetch('PREDICTION_URL')}/api/v1/tokens" }
  let(:client_secret) { ENV.fetch('PREDICTION_CLIENT_SECRET') }
  let(:client_id) { ENV.fetch('PREDICTION_CLIENT_ID') }
  let(:response_headers) { { 'Content-Type' => 'application/json' } }
  let(:headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Faraday v2.12.2',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
  end

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:response) { described_class.new.create_resource }

    context 'when the response is successful' do
      let(:json_file) { 'token' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/analysis/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          body: URI.encode_www_form(
            'client_id' => Base64.strict_encode64(client_id),
            'client_secret' => Base64.strict_encode64(client_secret),
            'grant_type' => 'client_credentials'
          ),
          headers: headers
        ).to_return(status: 200, body: response_body, headers: response_headers)
      end

      it 'returns an Analysis::Prediction instance' do
        expect(response).to be_a(Analysis::Token)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(headers: headers)
          .to_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises a PredictionPostResponseError' do
        expect { response }.to raise_error(Faraday::ForbiddenError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(headers: headers)
          .to_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'raises a PredictionPostResponseError after retries' do
        expect { response }.to raise_error(
          Errors::Analysis::TokenPostResponseError
        )
      end
    end
  end
end
