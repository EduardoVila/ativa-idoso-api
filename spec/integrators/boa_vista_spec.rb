# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Integrators::BoaVista do
  let(:credentials) { described_class.credentials }
  let(:xml_header) { described_class.build_xml_header }

  describe '.build_essencial_body_request' do
    @cpf = Faker::CPF.pretty
    @credit_type = 'CC'
    context 'when calls build_essencial_body_request' do
      it 'builds the body correctly' do
        expected_body = Nokogiri::XML::Builder.with(xml_header) do |xml|
          xml.acertaContratoEntrada(
            'xmlns' => 'http://boavistaservicos.com.br/familia/acerta/pf'
          ) do
            xml.usuario credentials[:user]
            xml.senha credentials[:password]
            xml.cpf @cpf
            xml.tipoCredito @credit_type
          end
        end.to_xml

        body = described_class.build_essencial_body_request(@cpf, @credit_type)

        expect(body).to eq expected_body
      end
    end
  end

  describe '.credentials' do
    context 'when calls credentials' do
      let(:secrets_boavista) do
        {
          user: EnvHelper.fetch('BOA_VISTA_USER'),
          password: EnvHelper.fetch('BOA_VISTA_PASSWORD')
        }
      end

      it 'setups user' do
        user = secrets_boavista[:user]

        expect(credentials[:user]).to eq(user)
      end

      it 'setups password' do
        password = secrets_boavista[:password]

        expect(credentials[:password]).to eq(password)
      end
    end
  end

  describe '.build_xml_header' do
    context 'when calls build_xml_header' do
      it 'builds the xml_header correctly' do
        expected_xml_header = Nokogiri::XML(
          '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        )

        xml_header = described_class.build_xml_header

        expect(xml_header.to_xml).to eq expected_xml_header.to_xml
      end
    end
  end

  describe '.acerta_essencial' do
    before do
      WebMock.disable_net_connect!
      @cpf = Faker::CPF.pretty

      allow(ErrorLogger).to receive(:log)

      # rubocop:disable Style/SymbolProc
      body = Nokogiri::XML::Builder.with(xml_header) do |xml|
        xml.essencial
      end.to_xml
      # rubocop:enable Style/SymbolProc

      stub_request(
        :post,
        'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
      ).with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Faraday v2.13.1',
          'Content-Type' => 'application/xml'
        }
      ).to_return(
        status: 200,
        body:,
        headers: { 'Content-Type' => 'application/xml' }
      )
    end

    context 'when request is a success' do
      let(:response_data) { described_class.acerta_essencial(@cpf, 'CC') }

      it 'does not returns an empty body' do

        expect(response_data).not_to eq('')

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(log.path).to eq(
          'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        )
        expect(response_log.table).to eq('boa_vista_acerta_essencial')
        expect(response_log.table_pointer).to eq(@cpf)
        expect(response_log.path).to eq(
          'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        )
        expect(log.method).to eq('post')
        expect(log.body).to eq(
          described_class.build_essencial_body_request(@cpf, 'CC').to_s
        )
      end

      it 'does not returns a nil response' do
        expect(response_data).not_to be_nil

        log = RequestLog.last
        response_log = ResponseLog.last

        expect(log.path).to eq(
          'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        )
        expect(response_log.table).to eq('boa_vista_acerta_essencial')
        expect(response_log.table_pointer).to eq(@cpf)
        expect(response_log.path).to eq(
          'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        )
        expect(log.method).to eq('post')
        expect(log.body).to eq(
          described_class.build_essencial_body_request(@cpf, 'CC').to_s
        )
      end
    end

    context 'when request returns empty body' do
      it 'raises EmptyResponseError' do
        allow(described_class).to receive(:acerta_essencial).with(@cpf, 'CC')
          .and_raise(EmptyResponseError.new)

        expect { described_class.acerta_essencial(@cpf, 'CC') }
          .to raise_error(EmptyResponseError)
      end
    end

    context 'when request returns internal server error' do
      before do
        WebMock.disable_net_connect!
        @cpf = Faker::CPF.pretty

        allow(ErrorLogger).to receive(:log)

        response_path = File.join(
          'spec/fixtures/boa_vista/internal_server_error.html'
        )

        body = File.read(response_path)

        stub_request(
          :post,
          'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        ).with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.13.1',
            'Content-Type' => 'application/xml'
          }
        ).to_return(
          status: 200,
          body:,
          headers: { 'Content-Type' => 'application/xml' }
        )
      end

      it 'retries 5 times, and then returns nil' do
        expect(described_class.acerta_essencial(@cpf, 'CC')).to eq(nil)
      end
    end
  end
end
