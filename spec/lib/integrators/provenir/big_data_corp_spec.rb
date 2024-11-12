# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require 'concerns/integrable'
require_relative '../../../integrable'
require_relative '../../../../lib/integrators/provenir/big_data_corp'
# rubocop:disable Layout/LineLength
require_relative '../../../../lib/errors/provenir/big_data_corp_post_response_error'
# rubocop:enable Layout/LineLength

RSpec.describe Integrators::Provenir::BigDataCorp do
  let(:url) { ENV.fetch('PROVENIR_BIG_DATA_CORP_URL') }
  let(:client_secret) { ENV.fetch('PROVENIR_CLIENT_SECRET') }
  let(:client_id) { ENV.fetch('PROVENIR_CLIENT_ID') }
  let(:access_token) { Base64.strict_encode64("#{client_id}:#{client_secret}") }
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
          File.join(__dir__, "../../../fixtures/provenir/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Basic #{access_token}"
          }
        ).to_return(status: 200, body: response_body, headers: response_headers)
      end

      it 'returns a Provenir::BigDataCorp instance' do
        expect(response).to be_a(Provenir::BigDataCorp)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Basic #{access_token}"
          }
        ).to_return(status: 403, body: nil, headers: response_headers)
      end

      it 'raises a BigDataCorpPostResponseError' do
        expect { response }.to raise_error(
          Errors::Provenir::BigDataCorpPostResponseError
        )
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Basic #{access_token}"
          }
        ).to_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'raises a BigDataCorpPostResponseError after retries' do
        expect { response }.to raise_error(
          Errors::Provenir::BigDataCorpPostResponseError
        )
      end
    end
  end
end
