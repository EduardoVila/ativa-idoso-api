# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'concerns/integrable'
require_relative '../../../integrable'
require_relative '../../../../lib/errors/provenir/big_data_corp_load_data_error'
require_relative '../../../../lib/integrators/provenir/big_data_corp'

RSpec.describe Integrators::Provenir::BigDataCorp do
  let(:url) { ENV.fetch('PROVENIR_BIG_DATA_CORP_URL') }
  let(:access_token) { Base64.strict_encode64("#{client_id}:#{client_secret}") }
  let(:client_secret) { ENV.fetch('PROVENIR_CLIENT_SECRET') }
  let(:client_id) { ENV.fetch('PROVENIR_CLIENT_ID') }
  let(:response_headers) { { 'Content-Type' => 'application/json' } }

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#load_data' do
    subject(:response) { described_class.new.load_data(analysis_item) }

    let(:analysis_item) { create :analysis_item }

    context 'when it returns 200' do
      context 'when there is all parent data' do
        let(:json_file) { 'big_data_corp' }
        let(:file) do
          File.join(
            File.dirname(__FILE__),
            "../../../fixtures/provenir/#{json_file}.json"
          )
        end
        let(:response_body) { File.read file }

        before do
          stub_request(:post, url).to_return(
            status: 200, body: response_body, headers: response_headers
          )
        end

        it { is_expected.to be_a Provenir::BigDataCorp }
      end

      context 'when any parent data of json is missing' do
        let(:json_file) { 'big_data_corp_missing_parent_data' }
        let(:file) do
          File.join(
            File.dirname(__FILE__),
            "../../../fixtures/provenir/#{json_file}.json"
          )
        end
        let(:response_body) { File.read file }

        before do
          stub_request(:post, url).to_return(
            status: 200, body: response_body, headers: response_headers
          )
        end

        it { is_expected.to be_a Provenir::BigDataCorp }
      end
    end

    context 'when it does not return 200' do
      let(:big_data_corp_load_data_error) do
        Errors::Provenir::BigDataCorpLoadDataError
      end

      before do
        stub_request(:post, url).to_return(
          status: 403, body: nil, headers: response_headers
        )
      end

      it { expect { response }.to raise_error big_data_corp_load_data_error }

      context 'when connection fails' do
        before do
          stub_request(:post, url).to_raise(
            Faraday::ConnectionFailed.new('Connection failed')
          )
        end

        it 'retries the request and raises an error after max retries' do
          instance = described_class.new

          allow(instance).to receive(:sleep).exactly(4).times
          expect do
            instance.load_data(analysis_item)
          end.to raise_error Errors::Provenir::BigDataCorpLoadDataError
        end
      end
    end
  end
end
