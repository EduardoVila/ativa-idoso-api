# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::Users, type: :handler do
  include Rack::Test::Methods

  describe 'POST /v1/users' do
    subject(:post_request) { post(route, valid_params, headers) }

    let(:route) { '/v1/users' }
    let(:valid_params) do
      build(:user).attributes.slice('name', 'cpf').to_json
    end
    let(:headers) { { 'Content-Type' => 'application/json' } }

    context 'when the request is valid' do
      it 'creates a new user and returns status 201' do
        expect { post_request }.to change(User, :count).by(1)
        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is invalid' do
      let(:valid_params) { {}.to_json }

      it 'does not create a new user and returns status 422' do
        expect { post_request }.not_to change(User, :count)
        expect(last_response.status).to eq(422)
      end
    end
  end
end
