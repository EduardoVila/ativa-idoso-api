require 'spec_helper'

RSpec.describe V1::AnonymousSessions, type: :handler do
  include Rack::Test::Methods

  let(:device_id) { SecureRandom.uuid }
  let(:headers) do
    {
      'HTTP_X_DEVICE_ID' => device_id,
      'CONTENT_TYPE' => 'application/json'
    }
  end

  describe 'POST /v1/anonymous_sessions' do
    it 'creates an anonymous user without requiring CPF' do
      expect do
        post '/v1/anonymous_sessions', nil, headers
      end.to change(User, :count).by(1)

      body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201)
      expect(body['anonymous']).to be(true)
      expect(body['cpf']).to be_nil
      expect(body['access_token']).to be_present
    end

    it 'returns the existing session for the same device' do
      post '/v1/anonymous_sessions', nil, headers
      first_body = JSON.parse(last_response.body)

      expect do
        post '/v1/anonymous_sessions', nil, headers
      end.not_to change(User, :count)

      second_body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(second_body['id']).to eq(first_body['id'])
      expect(second_body['access_token']).to eq(first_body['access_token'])
    end

    it 'rejects an invalid device id' do
      post '/v1/anonymous_sessions', nil, {
        'HTTP_X_DEVICE_ID' => 'not-a-uuid'
      }

      expect(last_response.status).to eq(422)
    end
  end
end
