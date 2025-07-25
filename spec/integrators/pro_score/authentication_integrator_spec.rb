# frozen_string_literal: true

require 'spec_helper'
require_relative '../integrable'

RSpec.describe ProScore::AuthenticationIntegrator do
  subject { described_class.new }

  let(:url) { 'https://api.proscore.com.br/oauth/token' }
  let(:headers) { { headers: { 'Content-Type' => 'application/json' } } }

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '.authenticate' do
    context 'when it returns 200' do
      let(:body_path) do
        File.join(__dir__, '..', '..', 'fixtures',
                  'pro_score', 'authentication_response.json')
      end
      let(:body) { File.read(body_path) }

      before do
        stub_request(:post, url).to_return(status: 200, body:, headers:)
      end

      it 'returns an instance of ProScore::Authentication' do
        expect(subject.authenticate).to be_a(ProScore::Authentication)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(headers)
          .to_return(status: 401, body: nil, headers:)
      end

      it 'raises a Errors::ProScore::ResponseError' do
        expect { subject.authenticate }
          .to raise_error(Errors::ProScore::ResponseError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(headers)
          .to_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'raises a Errors::ProScore::ResponseError after retries' do
        expect { subject.authenticate }
          .to raise_error(Errors::ProScore::ResponseError)
      end
    end
  end
end
