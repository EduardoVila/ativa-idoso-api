# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe RequestLogger do
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
      stub_request(:post, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'User-Agent' => 'Faraday v2.13.1',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    it 'creates the log correclty' do
      expect(RequestLog.count).to eq(0)

      conn.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = expected_body

        described_class.log(req)
      end

      expect(RequestLog.count).to eq(1)

      log = RequestLog.last

      expect(log.method).to eq('post')
      expect(log.path).to eq(url)
      expect(log.body).to eq(expected_body.to_s)
    end
  end
end
