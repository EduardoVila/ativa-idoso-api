# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../../../app/handlers/v1/authenticate'
require 'bcrypt'

RSpec.describe V1::Authenticate, type: :handler do
  include Rack::Test::Methods

  describe 'POST /v1/authenticate' do
    let(:route) { '/v1/authenticate' }
    let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' } }

    context 'when the request is valid' do
      let(:json_response) { JSON.parse(last_response.body) }
      let(:api_client) { create :api_client }
      let(:client_id) { 'client_id' }
      let(:client_secret) { 'client_secret' }
      let(:client_id_base64) { Base64.strict_encode64(client_id) }
      let(:client_secret_base64) { Base64.strict_encode64(client_secret) }
      let(:hashed_client_secret) { BCrypt::Password.create(client_secret) }
      let(:body) do
        {
          grant_type: 'client_credentials',
          client_id: client_id_base64,
          client_secret: client_secret_base64
        }
      end

      before do
        api_client.update(
          client_id: client_id,
          client_secret: hashed_client_secret
        )
      end

      it 'returns a token with status 200' do
        post(route, body, headers)

        expect(last_response.status).to eq(200)
        expect(json_response).to have_key('access_token')
        expect(json_response['token_type']).to eq('Bearer')
        expect(json_response['expires_in']).to eq(604_800)
      end
    end

    context 'when the request is invalid' do
      it 'returns 401 if the content type is incorrect' do
        post(
          route,
          {
            grant_type: 'client_credentials',
            client_id: 'some_id',
            client_secret: 'some_secret'
          },
          headers
        )

        expect(last_response.status).to eq(401)
      end

      it 'returns 401 if grant_type is missing or invalid' do
        post(route, { client_id: 'foo', client_secret: 'bar' }, headers)

        expect(last_response.status).to eq(401)
      end

      it 'returns 401 if client_id or client_secret is missing' do
        post(route, { grant_type: 'client_credentials' }, headers)

        expect(last_response.status).to eq(401)
      end

      it 'returns 401 if client credentials are not in base64' do
        post(route, { client_id: 'not_b64', client_secret: 'not_b64' }, headers)

        expect(last_response.status).to eq(401)
      end
    end
  end
end
