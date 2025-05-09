# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'dotenv/load'
require_relative '../integrable'
require_relative '../../../app/integrators/serasa/fintech_report_integrator'
require_relative '../../../app/integrators/errors/serasa/response_error'
require_relative '../../../app/integrators/errors/serasa/not_found_error'

RSpec.describe Serasa::FintechReportIntegrator do
  let(:url) { EnvHelper.fetch('SERASA_FINTECH_REPORT_URL') }
  let(:token) { 'fake_token' }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
  let(:response_headers) { { 'Content-Type' => 'application/json' } }

  before do
    allow(Serasa::AuthenticationService).to receive(:call).and_return(token)
    WebMock.disable_net_connect!
  end

  it_behaves_like 'integrable', described_class

  describe '#load_data' do
    subject(:response) { described_class.new.load_data(analysis_item) }

    let(:analysis_item) { create :analysis_item }

    context 'when the response is successful' do
      let(:json_file) { 'fintech_response' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/serasa/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          headers: headers,
          body: post_body(analysis_item)
        ).to_return(status: 200, body: response_body, headers: response_headers)
      end

      it 'returns a Serasa::FintechReport instance' do
        expect(response).to be_a(Serasa::FintechReport)
      end

      it 'saves the serasa_fintech_report' do
        expect { response }.to change(Serasa::FintechReport, :count).by(1)
      end
    end

    context 'when response status is 404 and not found message is present' do
      let(:json_file) { 'not_found_response' }
      let(:response_body) do
        File.read(
          File.join(__dir__, "../../fixtures/serasa/#{json_file}.json")
        )
      end

      before do
        stub_request(:post, url).with(
          headers: headers,
          body: post_body(analysis_item)
        ).to_return(status: 404, body: response_body, headers: response_headers)
      end

      it 'raises a Faraday::ResourceNotFound' do
        expect { response }.to raise_error(Faraday::ResourceNotFound)
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:post, url).with(
          headers: headers,
          body: post_body(analysis_item)
        ).to_return(status: 500, body: '', headers: response_headers)
      end

      it 'raises a Faraday::ServerError with the response status' do
        expect { response }.to raise_error(Faraday::ServerError)
      end
    end

    context 'when a Faraday::ConnectionFailed error occurs' do
      before do
        stub_request(:post, url).with(
          headers: headers,
          body: post_body(analysis_item)
        ).to_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'raises a Errors::Serasa::ResponseError after retries' do
        expect { response }.to raise_error(Errors::Serasa::ResponseError)
      end
    end
  end

  def post_body(analysis_item)
    {
      'documentNumber' => CPF::Formatter.strip(analysis_item.cpf),
      'reportName' => 'COMBO_CONCESSAO_COM_analysis_item_POSITIVO',
      'optionalFeatures' => []
    }.to_json
  end
end
