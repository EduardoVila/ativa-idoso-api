# frozen_string_literal: true

RSpec.shared_examples 'integrable' do |klass|
  require 'webmock/rspec'

  describe '#do_request' do
    before { WebMock.disable_net_connect! }

    let(:url) { Faker::Internet.url }
    let(:json_key) { 'Internet.username' }
    let(:json_value) { 'Internet.password' }
    let(:options_hash) { { key: json_key, value: json_value } }
    let(:response_data) do
      Faker::Json.shallow_json(width: 3, options: options_hash)
    end
    let(:headers) { { 'app-token' => Faker::Internet.uuid } }
    let(:params) { { 'id' => Faker::Internet.uuid } }

    context 'when load' do
      it 'sets connection object' do
        expect(klass.new.conn).to be_a Faraday::Connection
      end
    end

    context 'when doing a get request' do
      let(:verb) { :get }
      let(:response) { klass.new.do_request(verb, url, headers, params) }
      let(:json) { JSON.parse(response.body) }

      before do
        stub_request(verb, url).to_return(
          status: 200, body: response_data.to_s, headers: headers
        )
      end

      it { expect(json['data']).to eq response_data['data'] }
    end
  end
end
