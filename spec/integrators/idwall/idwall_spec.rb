# frozen_string_literal: true

require 'webmock/rspec'

require_relative '../../data_loaders/idwall/base'
require_relative '../../data_loaders/idwall/report'
require_relative '../../../app/integrators/idwall'
require_relative '../../../app/integrators/errors/integrators/idwall_response_error'

RSpec.describe DataLoaders::Idwall::Report do
  let(:credentials) { Integrators::Idwall.credentials }
  let(:cpf) { Faker::CPF.pretty }

  describe '.create_report' do
    before do
      WebMock.disable_net_connect!

      @stub_request = stub_request(:post, Integrators::Idwall.build_url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.0',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    it 'returns the correct number' do
      response = @stub_request.response
      response.body = '{
        "result": {
            "numero": "68a258da-9d7e-4b20-acb0-0259ba325837"
        },
        "status_code": 200
      }'
      report = described_class
      created_report = report.create_report(cpf, ['SP'])

      expect(created_report)
        .to eq({
                 'numero' => '68a258da-9d7e-4b20-acb0-0259ba325837'
               })
    end

    it 'returns nil' do
      response = @stub_request.response
      response.body = '{
        "error": "Bad Request",
        "message": "Parâmetro \"cpf_numero\" não é válido.",
        "status_code": 400
      }'
      report = described_class
      created_report = report.create_report(cpf, ['SP'])

      expect(created_report).to be_nil
    end
  end

  describe '.check_status' do
    let(:number) { 'b890be4e-97d0-4df0-a186-cc19d9bb7feb' }

    before do
      WebMock.disable_net_connect!

      @stub_request = stub_request(
        :get,
        Integrators::Idwall.build_url([number])
      )
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.0',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    it 'returns the correct number' do
      response = @stub_request.response
      response.body = '{
        "result": {
            "numero": "b890be4e-97d0-4df0-a186-cc19d9bb7feb",
            "status": "CONCLUIDO",
            "nome": "alpop_bcg_pf",
            "mensagem": "Válido.",
            "resultado": "VALID",
            "validado_em": "2021-03-16T14:37:46.567Z",
            "validado_por": null,
            "validado_manualmente": false,
            "atualizado_em": "2021-03-16T14:41:21.576Z",
            "criado_em": "2021-03-16T14:37:46.429Z",
            "criado_por": "caio_alpop"
        },
        "status_code": 200
      }'
      report = described_class
      checked_status = report.check_status(number)

      expect(checked_status).to eq('processed')
    end

    it 'returns nil' do
      response = @stub_request.response
      response.body = '{
        "error": "Not Found",
        "message": "Protocolo não encontrado.",
        "status_code": 404
      }'
      report = described_class
      created_report = report.check_status(number)

      expect(created_report).to be_nil
    end
  end

  describe '.load' do
    let(:number) { 'b890be4e-97d0-4df0-a186-cc19d9bb7feb' }
    let!(:report) { create :idwall_report, number:, status: 'processed' }

    before do
      WebMock.disable_net_connect!

      @stub_request = stub_request(
        :get,
        Integrators::Idwall.build_url([number, 'dados'])
      )
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.12.0',
            'Authorization' => credentials[:token]
          }
        )
        .to_return(status: 200, body: '{}', headers: {})
    end

    it 'returns a valid modular object' do
      response = @stub_request.response
      response.body = '{
        "result": {
          "atualizado_em": "2021-03-16T14:06:15.695Z",
          "criado_em": "2021-03-16T14:03:45.493Z",
          "mensagem": "Válido.",
          "nome": "alpop_bcg_pf",
          "numero": "b890be4e-97d0-4df0-a186-cc19d9bb7feb",
          "resultado": "VALID",
          "status": "CONCLUIDO",
          "validado_em": "2021-03-16T14:03:45.627Z"
        },
        "status_code": 200
      }'
      report = described_class
      loaded = report.load(number)

      expect(loaded.raw_data).to be_truthy
      expect(loaded).to be_valid
    end

    it 'returns nil' do
      response = @stub_request.response
      response.body = '{
        "error": "Not Found",
        "message": "Protocolo não encontrado.",
        "status_code": 404
      }'
      report = described_class
      created_report = report.load(number)

      expect(created_report).to be_nil
    end
  end
end
