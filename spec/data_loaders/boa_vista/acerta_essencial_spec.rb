# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe DataLoaders::BoaVista::AcertaEssencial do
  describe '.load' do
    let(:analysis_item) { create :analysis_item }

    context 'when load is called' do
      before do
        WebMock.disable_net_connect!

        boa_vista_response_path = File.join(
          __dir__, '../../fixtures/boa_vista/response.xml'
        )
        body = Nokogiri::XML(File.open(boa_vista_response_path)).to_xml

        # rubocop:disable Layout/LineLength
        stub_request(:post, 'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3')
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v2.12.0',
              'Content-Type' => 'application/xml'
            }
          )
          .to_return(status: 200, body:, headers: { 'Content-Type' => 'application/xml' })
        # rubocop:enable Layout/LineLength
      end

      it 'returns a valid boa_vista_acerta_essencial xml' do
        acerta_essencial = described_class
        boa_vista_acerta_essencial = acerta_essencial.load(Faker::CPF.pretty,
                                                           'CC')
        boa_vista_acerta_essencial.update(consumer: analysis_item)

        expect(boa_vista_acerta_essencial).to be_valid
      end

      it 'returns a boa_vista_acerta_essencial with the column raw_data' do
        acerta_essencial = described_class
        boa_vista_acerta_essencial = acerta_essencial.load(Faker::CPF.pretty,
                                                           'CC')
        boa_vista_acerta_essencial.update(consumer: analysis_item)

        expect(boa_vista_acerta_essencial).to be_valid
        expect(boa_vista_acerta_essencial.raw_data).to be_truthy
      end
    end
  end
end
