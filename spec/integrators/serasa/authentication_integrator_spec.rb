# frozen_string_literal: true

require 'base64'
require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/serasa/authentication_integrator'
require_relative '../../../app/integrators/errors/serasa/response_error'

RSpec.describe Serasa::AuthenticationIntegrator do
  let(:post_url) do
    ENV.fetch('SERASA_FINTECH_REPORT_LOGIN_URL')
  end
  let(:username) do
    Base64.strict_encode64(ENV.fetch('SERASA_FINTECH_REPORT_USERNAME'))
  end
  let(:password) do
    Base64.strict_encode64(ENV.fetch('SERASA_FINTECH_REPORT_PASSWORD'))
  end
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "basic #{username}:#{password}"
    }
  end
  let(:response_headers) { { 'Content-Type' => 'application/json' } }

  before { WebMock.disable_net_connect! }

  it_behaves_like 'integrable', described_class

  describe '#authenticate' do
    subject(:response) { described_class.new.authenticate }

    context 'when the authentication is successful' do
      let(:json_file) { 'authentication_response' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/serasa/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, post_url)
          .with(
            headers: headers,
            body: '{}'
          ).to_return(
            status: 201, body: response_body, headers: response_headers
          )
      end

      it 'returns a Serasa::Authentication instance' do
        expect(response).to be_a(Serasa::Authentication)
      end

      it 'saves the Serasa::Authentication record' do
        expect { response }.to change(Serasa::Authentication, :count).by(1)
      end
    end

    context 'when the authentication fails' do
      before do
        stub_request(:post, post_url)
          .with(
            headers: headers,
            body: '{}'
          ).to_return(status: 401, body: '', headers: response_headers)
      end

      it 'raises a Errors::Serasa::ResponseError with the response status' do
        expect { response }.to raise_error(Errors::Serasa::ResponseError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, post_url)
          .with(
            headers: headers,
            body: '{}'
          ).to_raise(Errors::Serasa::ResponseError)
      end

      it 'raises a Errors::Serasa::ResponseError after retries' do
        expect { response }.to raise_error(Errors::Serasa::ResponseError)
      end
    end
  end
end
