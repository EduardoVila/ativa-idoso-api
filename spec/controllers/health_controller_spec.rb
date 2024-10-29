# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/health_controller'
require_relative '../../app/controllers/concerns/tokenable'
require 'json'

# Helper method to generate a valid token
def generate_valid_token(api_client)
  payload = { client_id: api_client.client_id, exp: Time.now.to_i + 3600 }
  Tokenable.encode(payload)
end

RSpec.describe HealthController, type: :controller do
  include Rack::Test::Methods

  let(:app) { described_class }
  let(:json_response) { JSON.parse(last_response.body) }

  describe 'GET /' do
    it 'returns health status 200' do
      get '/'

      expect(last_response.status).to eq(200)
      expect(json_response).to include('message' => 'Health: OK')
    end
  end

  describe 'GET /protected' do
    context 'when the request is valid' do
      before do
        api_client = create(:api_client)
        valid_token = generate_valid_token(api_client)
        header 'Authorization', "Bearer #{valid_token}"
        get '/protected'
      end

      it 'returns protected health status 200' do
        expect(last_response.status).to eq(200)
        expect(json_response).to include('message' => 'Protected health: OK')
      end
    end

    context 'when the access token is missing' do
      it 'returns 401 Unauthorized' do
        get '/protected'

        expect(last_response.status).to eq(401)
      end
    end

    context 'when the access token is invalid' do
      it 'returns 401 Unauthorized' do
        header 'Authorization', 'Bearer invalid_token'
        get '/protected'

        expect(last_response.status).to eq(401)
      end
    end
  end
end
