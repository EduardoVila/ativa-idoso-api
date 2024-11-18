# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../../../../app/controllers/application_controller'
require_relative '../../../../app/controllers/api/v1/tokens_controller'
require 'bcrypt'

RSpec.describe API::V1::TokensController, type: :controller do
  include Rack::Test::Methods

  describe 'POST /api/v1/tokens' do
    context 'when the request is valid' do
      let(:json_response) { JSON.parse(last_response.body) }
      let(:api_client) { create :api_client }
      let(:client_id) { 'client_id' }
      let(:client_secret) { 'client_secret' }
      let(:client_id_base64) { Base64.strict_encode64(client_id) }
      let(:client_secret_base64) { Base64.strict_encode64(client_secret) }
      let(:hashed_client_secret) { BCrypt::Password.create(client_secret) }

      before do
        api_client.update(
          client_id: client_id,
          client_secret: hashed_client_secret
        )
      end

      it 'returns a token with status 200' do
        post '/api/v1/tokens',
             {
               grant_type: 'client_credentials',
               client_id: client_id_base64,
               client_secret: client_secret_base64
             },
             { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' }

        expect(last_response.status).to eq(200)
        expect(json_response).to have_key('access_token')
        expect(json_response['token_type']).to eq('bearer')
        expect(json_response['expires_in']).to eq(10_080)
      end
    end

    context 'when the request is invalid' do
      it 'returns 401 if the content type is incorrect' do
        post '/api/v1/tokens',
             {
               grant_type: 'client_credentials',
               client_id: 'some_id',
               client_secret: 'some_secret'
             },
             { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(401)
      end

      it 'returns 401 if grant_type is missing or invalid' do
        post '/api/v1/tokens',
             { client_id: 'some_id', client_secret: 'some_secret' },
             { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' }

        expect(last_response.status).to eq(401)
      end

      it 'returns 401 if client_id or client_secret is missing' do
        post '/api/v1/tokens', { grant_type: 'client_credentials' },
             { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' }

        expect(last_response.status).to eq(401)
      end
    end
  end
end
