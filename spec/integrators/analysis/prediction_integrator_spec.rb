# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/analysis/prediction_integrator'
# rubocop: disable Layout/LineLength
require_relative '../../../app/integrators/errors/analysis/prediction_response_error'
# rubocop: enable Layout/LineLength

RSpec.describe Analysis::PredictionIntegrator do
  let!(:token) { create :prediction_token }
  let(:url) { EnvHelper.fetch('PREDICTION_URL') }
  let(:request_headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Faraday v2.12.2',
      'Content-Type' => 'application/json'
    }
  end
  let(:response_headers) { { 'Content-Type' => 'application/json' } }

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:response) { described_class.new.create_resource(analysis_item) }

    let(:analysis_item) { create :analysis_item }

    context 'when the response is successful' do
      let(:json_file) { 'prediction' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/analysis/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          headers: request_headers,
          body: {
            cpf: analysis_item.cpf,
            features: analysis_item.featurable,
            prediction_model_name: nil
          }.to_json
        ).to_return(status: 200, body: response_body, headers: response_headers)
      end

      it 'returns an Analysis::Prediction instance' do
        expect(response).to be_a(Analysis::Prediction)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(headers: request_headers)
          .to_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises a Faraday::ForbiddenError' do
        expect do
          response
        end.to raise_error(Faraday::ForbiddenError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(headers: request_headers)
          .to_raise(Errors::Analysis::PredictionPostResponseError)
      end

      it 'raises a PredictionPostResponseError after retries' do
        expect { response }.to raise_error(
          Errors::Analysis::PredictionPostResponseError
        )
      end
    end
  end

  describe '#show_resource' do
    subject(:response) { described_class.new.show_resource(prediction_id) }

    let(:prediction_id) { '123' }
    let(:get_url) { "#{url}/#{prediction_id}" }

    context 'when the response is successful' do
      let(:json_file) { 'prediction' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/analysis/#{json_file}.json")
        )
      end

      before do
        stub_request(:get, get_url)
          .with(headers: request_headers)
          .to_return(
            status: 200,
            body: response_body,
            headers: response_headers
          )
      end

      it 'returns an Analysis::Prediction instance' do
        expect(response).to be_a(Analysis::Prediction)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:get, get_url)
          .with(headers: request_headers)
          .to_return(
            status: 403,
            body: nil,
            headers: response_headers
          )
      end

      it 'raises a PredictionPostResponseError' do
        expect { response }.to raise_error(Faraday::ForbiddenError)
      end
    end

    context 'when a connection error occurs' do
      before do
        stub_request(:get, get_url)
          .with(headers: request_headers)
          .to_raise(Errors::Analysis::PredictionGetResponseError)
      end

      it 'raises a PredictionGetResponseError' do
        expect { response }.to raise_error(
          Errors::Analysis::PredictionGetResponseError
        )
      end
    end
  end
end
