# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::Researches, type: :handler do
  include Rack::Test::Methods

  describe 'GET /v1/researches' do
    subject(:get_request) { get(route, nil, headers) }

    let(:route) { "/v1/researches/#{research.id}" }
    let(:research) { create :research }
    let(:user) {  create :user }
    let(:headers) do
      {
        'Content-Type' => 'application/json',
        'Authorization' => user.access_token
      }
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }

      it 'returns status 401' do
        get_request

        expect(last_response.status).to eq(401)
      end
    end

    context 'when the research exists' do
      it 'returns the research and status 200' do
        get_request

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(research.serialize_record.to_json)
      end
    end

    context 'when the research does not exist' do
      let(:route) { '/v1/researches/9999' }

      it 'returns an error message and status 404' do
        get_request

        expect(last_response.status).to eq(404)
      end
    end
  end
end
