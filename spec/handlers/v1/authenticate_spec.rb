# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::Authenticate, type: :handler do
  include Rack::Test::Methods

  describe 'POST /v1/authenticate' do
    let(:route) { '/v1/authenticate' }
    let(:user) { create :user }

    context 'when the user is not authenticated' do
      it 'returns status 401' do
        post route

        expect(last_response.status).to eq(401)
      end
    end

    context 'when the user is authenticated' do
      let(:headers) do
        {
          'Content-Type' => 'application/json',
          'Authorization' => user.access_token
        }
      end

      it 'returns the user and status 200' do
        post route, nil, headers

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(user.serialize_record.to_json)
      end
    end
  end
end
