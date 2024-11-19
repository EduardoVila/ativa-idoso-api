# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

require_dependency 'response_logger' # ensuring autoload works for tdd-flow

RSpec.describe ResponseLogger do
  describe '#log(req)' do
    let(:url) { 'https://blabla.com' }
    let(:conn) do
      Faraday.new do |c|
        c.request :url_encoded
        c.adapter :net_http
      end
    end
    let(:expected_body) { { name: 'Eduardo de Vila' } }

    before do
      WebMock.disable_net_connect!

      allow(ErrorLogger).to receive(:log)

      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'User-Agent' => 'Faraday v2.12.0',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    context 'when response is a Faraday::Response' do
      it 'creates the log correctly' do
        expect(ResponseLog.count).to eq(0)

        response = conn.post do |req|
          req.url url
          req.headers['Content-Type'] = 'application/json'
          req.body = expected_body
        end

        described_class.log(response, 'blabla', 2)

        expect(ResponseLog.count).to eq(1)

        log = ResponseLog.last

        expect(log.method).to eq('post')
        expect(log.path).to eq(url)
        expect(log.table).to eq('blabla')
      end
    end

    context 'when response is not a Faraday::Response' do
      let(:fake_response) do
        {
          method: 'get',
          url:,
          body: 'fake_body',
          headers: { 'Content-Type' => 'text/plain' },
          status: 404
        }
      end

      it 'creates the log correctly for non-Faraday::Response' do
        expect(ResponseLog.count).to eq(0)

        described_class.log(fake_response, 'blabla', 2)

        expect(ResponseLog.count).to eq(1)

        log = ResponseLog.last

        expect(log.method).to eq('get')
        expect(log.path).to eq(url)
        expect(log.table).to eq('blabla')
      end
    end
  end
end
