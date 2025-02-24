# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/provenir/big_data_corp_integrator'
# rubocop: disable Layout/LineLength
require_relative '../../../app/integrators/errors/provenir/big_data_corp_post_response_error'
# rubocop: enable Layout/LineLength

RSpec.describe Provenir::BigDataCorpIntegrator do
  let(:url) { ENV.fetch('PROVENIR_BIG_DATA_CORP_URL') }
  let(:response_headers) { { 'Content-Type' => 'application/json' } }

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#create_resource' do
    subject(:response) { described_class.new.create_resource(analysis_item) }

    let(:analysis_item) { create :analysis_item }

    context 'when the response is successful' do
      let(:json_file) { 'big_data_corp' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/provenir/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          headers: { 'Content-Type' => 'application/json' }
        ).to_return(status: 200, body: response_body, headers: response_headers)
      end

      it 'returns a Provenir::BigDataCorp instance' do
        expect(response).to be_a(Provenir::BigDataCorp)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(
          headers: { 'Content-Type' => 'application/json' }
        ).to_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises a BigDataCorpPostResponseError' do
        expect do
          response
        end.to raise_error(Faraday::ForbiddenError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(
          headers: { 'Content-Type' => 'application/json' }
        ).to_raise(Errors::Provenir::BigDataCorpPostResponseError)
      end

      it 'raises a BigDataCorpPostResponseError after retries' do
        expect { response }.to raise_error(
          Errors::Provenir::BigDataCorpPostResponseError
        )
      end
    end
  end
end
