# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'helpers/boa_vista/cadastral_helpers'
require_relative '../integrable'

RSpec.configure do |c|
  c.include CadastralHelpers, :cadastral_helpers
end

RSpec.describe BoaVista::CadastralIntegrator, :cadastral_helpers do
  let(:cpf) { Faker::CPF.pretty }
  let(:url) { ENV.fetch('BOA_VISTA_CADASTRAL_URL') }
  let(:success) { 200 }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'user' => ENV.fetch('BOA_VISTA_USER'),
      'password' => ENV.fetch('BOA_VISTA_PASSWORD')
    }
  end

  it_behaves_like 'integrable', described_class

  describe '.load_data' do
    subject { described_class.new.load_data(cpf) }

    before do
      WebMock.disable_net_connect!
    end

    context 'when it is success' do
      before do
        stub_request(:post, url).with(
          headers:,
          body: request_body(cpf)
        ).to_return(
          status: success,
          body: success_body
        )
      end

      it 'creates boa vista cadastral correctly' do
        expect { subject }.to change(BoaVista::Cadastral, :count).by(1)
      end
    end

    context 'when does not exist data on boa vista' do
      before do
        stub_request(:post, url).with(
          headers:,
          body: request_body(cpf)
        ).to_return(
          status: success,
          body: not_found_body
        )
      end

      it 'raises a StandardError' do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context 'when it is error' do
      before do
        stub_request(:post, url).with(
          headers:,
          body: request_body(cpf)
        ).to_return(
          status: success,
          body: '{}'
        )
      end

      it 'raises ProScoreResponseError' do
        expect { subject }.to raise_error(BoaVistaResponseError)
      end
    end
  end
end
