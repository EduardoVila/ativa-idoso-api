# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/health_controller'
require_relative '../../app/controllers/concerns/tokenable'
require 'json'

# Helper method to generate a valid token
def generate_valid_token_helper(api_client)
  payload = { 'sub' => api_client.client_id }

  Tokenable.create_jwt(payload: payload)
end

RSpec.describe HealthController, type: :controller do
  include Rack::Test::Methods

  describe 'GET /protected' do
    let(:app) { described_class }
    let(:json_response) { JSON.parse(last_response.body) }

    context 'when the request is valid' do
      before do
        api_client = create :api_client
        valid_token = generate_valid_token_helper(api_client)
        PublicKey.create(
          key: ENV.fetch('RSA_PUBLIC_KEY').gsub('\\n', "\n"),
          issuer: 'alpop-analysis',
          algorithm: 'RS256',
          valid_from: Time.now,
          valid_to: Time.now + 1.year
        )

        header 'Authorization', "Bearer #{valid_token}"
        get '/protected'
      end

      it 'returns protected health status 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'when the access token is missing' do
      it 'returns 401 Unauthorized' do
        get '/protected'

        expect(last_response.status).to eq(401)
      end
    end
  end
end
