# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Integrators::Idwall do
  let(:credentials) { described_class.credentials }

  describe '.build_url' do
    context 'when calls build_url' do
      let(:expected_url) { 'https://api-v2.idwall.co/relatorios' }

      it 'builds the url' do
        url = described_class.build_url

        expect(url).to eq expected_url
      end
    end
  end

  describe '.has_error?' do
    context 'when pass 500 as status' do
      let(:status) { 500 }

      it 'returns true' do
        expect(described_class).to have_error(status)
      end
    end

    context 'when pass 400 as status' do
      let(:status) { 400 }

      it 'returns true' do
        expect(described_class).to have_error(status)
      end
    end

    context 'when pass 401 as status' do
      let(:status) { 401 }

      it 'returns true' do
        expect(described_class).to have_error(status)
      end
    end

    context 'when pass 404 as status' do
      let(:status) { 404 }

      it 'returns true' do
        expect(described_class).to have_error(status)
      end
    end

    context 'when pass a success status' do
      let(:status) { 200 }

      it 'returns true' do
        expect(described_class).not_to have_error(status)
      end
    end
  end

  describe '.credentials' do
    context 'when calls credentials' do
      let(:secrets_idwall) { { token: EnvHelper.fetch('IDWALL_TOKEN') } }

      it 'setups token' do
        token = secrets_idwall[:token]
        expect(credentials[:token]).to eq(token)
      end
    end
  end

  describe '.create_report' do
    let(:cpf) { Faker::CPF.pretty }
    let(:credentials) { described_class.credentials }
    let(:states) { %w[SC SP] }

    before do
      WebMock.disable_net_connect!
      stub_request(:post, described_class.build_url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.2',
            'Content-Type' => 'application/json',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    context 'when request is a success' do
      let(:response_data) { described_class.create_report(cpf, states) }

      it 'does not returns an empty body' do
        expect(response_data).not_to eq('')

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(described_class.build_url)
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(cpf)
        expect(log.path).to eq(described_class.build_url)
        expect(log.method).to eq('post')
      end

      it 'does not returns a nil response' do
        expect(response_data).not_to be_nil

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(described_class.build_url)
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(cpf)
        expect(log.path).to eq(described_class.build_url)
        expect(log.method).to eq('post')
      end
    end

    context 'when request returns error status' do
      it 'raises IdwallResponseError' do
        allow(described_class).to receive(:create_report).with(cpf, states)
          .and_raise(IdwallResponseError.new)

        expect { described_class.create_report(cpf, states) }
          .to raise_error(IdwallResponseError)
      end

      it 'returns the response body' do
        allow(described_class).to receive(:has_error?).and_return(true)
        allow(ErrorLogger).to receive(:log).and_return(true)

        expect(described_class.create_report(cpf, states)).to eq({})
      end
    end
  end

  describe '.report_status' do
    let(:cpf) { Faker::CPF.pretty }
    let(:credentials) { described_class.credentials }
    let(:number) { 'c890be4e-97d0-4df0-a186-cc19d9bb7fes' }
    let(:path_params) { [number] }

    before do
      WebMock.disable_net_connect!
      stub_request(:get, described_class.build_url(path_params))
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.2',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    context 'when request is a success' do
      let(:response_data) { described_class.report_status(number) }

      it 'does not returns an empty body' do
        expect(response_data).not_to eq('')

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(
          described_class.build_url(path_params)
        )
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(number)
        expect(log.path).to eq(described_class.build_url(path_params))
        expect(log.method).to eq('get')
      end

      it 'does not returns a nil response' do
        expect(response_data).not_to be_nil

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(
          described_class.build_url(path_params)
        )
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(number)
        expect(log.path).to eq(described_class.build_url(path_params))
        expect(log.method).to eq('get')
      end
    end

    context 'when request returns error status' do
      it 'raises IdwallResponseError' do
        allow(described_class).to receive(:report_status).with(number)
          .and_raise(IdwallResponseError.new)

        expect { described_class.report_status(number) }
          .to raise_error(IdwallResponseError)
      end

      it 'returns the response body' do
        allow(described_class).to receive(:has_error?).and_return(true)
        allow(ErrorLogger).to receive(:log).and_return(true)

        expect(described_class.report_status(number)).to eq({})
      end
    end
  end

  describe '.report_data' do
    let(:cpf) { Faker::CPF.pretty }
    let(:credentials) { described_class.credentials }
    let(:number) { 'c890be4e-97d0-4df0-a186-cc19d9bb7fes' }
    let(:path_params) { [number, 'dados'] }

    before do
      WebMock.disable_net_connect!

      allow(ErrorLogger).to receive(:log)

      stub_request(:get, described_class.build_url(path_params))
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.2',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    context 'when request is a success' do
      let(:response_data) { described_class.report_data(number) }

      it 'does not returns an empty body' do
        expect(response_data).not_to eq('')

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(
          described_class.build_url(path_params)
        )
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(number)
        expect(log.path).to eq(described_class.build_url(path_params))
        expect(log.method).to eq('get')
      end

      it 'does not returns a nil response' do
        expect(response_data).not_to be_nil

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(response_log.path).to eq(
          described_class.build_url(path_params)
        )
        expect(response_log.table).to eq('idwall')
        expect(response_log.table_pointer).to eq(number)
        expect(log.path).to eq(described_class.build_url(path_params))
        expect(log.method).to eq('get')
      end
    end

    context 'when request returns error status' do
      it 'raises IdwallResponseError' do
        allow(described_class).to receive(:report_data).with(number)
          .and_raise(IdwallResponseError.new)

        expect { described_class.report_data(number) }
          .to raise_error(IdwallResponseError)
      end

      it 'returns the response body' do
        allow(described_class).to receive(:has_error?).and_return(true)
        allow(ErrorLogger).to receive(:log).and_return(true)

        expect(described_class.report_data(number)).to eq({})
      end
    end
  end
end
