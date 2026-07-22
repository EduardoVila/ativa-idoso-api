require 'spec_helper'

RSpec.describe V1::SatisfactionSurveys, type: :handler do
  include Rack::Test::Methods

  let(:user) { create(:user, :authenticated) }
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_AUTHORIZATION' => user.access_token
    }
  end

  describe 'GET /v1/satisfaction_surveys' do
    it 'requires authentication' do
      get '/v1/satisfaction_surveys'

      expect(last_response.status).to eq(401)
    end

    it 'returns the questions when the user has not answered' do
      get '/v1/satisfaction_surveys', nil, headers

      body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(body['submitted']).to be(false)
      expect(body['questions'].size).to eq(4)
      expect(body['response']).to be_nil
    end

    it 'returns the submitted response' do
      response = create(:satisfaction_survey_response, user: user)

      get '/v1/satisfaction_surveys', nil, headers

      body = JSON.parse(last_response.body)

      expect(body['submitted']).to be(true)
      expect(body['response']['id']).to eq(response.id)
    end
  end

  describe 'POST /v1/satisfaction_surveys' do
    let(:payload) do
      {
        platform_access_score: 5,
        qr_code_access_score: 5,
        videos_understanding_score: 4,
        videos_motivation_score: 4
      }
    end

    it 'requires authentication' do
      post '/v1/satisfaction_surveys', payload.to_json

      expect(last_response.status).to eq(401)
    end

    it 'creates one response for the authenticated user' do
      post '/v1/satisfaction_surveys', payload.to_json, headers

      expect(last_response.status).to eq(201)
      expect(user.reload.satisfaction_survey_response).to have_attributes(
        platform_access_score: 5,
        qr_code_access_score: 5,
        videos_understanding_score: 4,
        videos_motivation_score: 4
      )
    end

    it 'rejects scores outside the 1..5 range' do
      payload[:qr_code_access_score] = 6

      post '/v1/satisfaction_surveys', payload.to_json, headers

      expect(last_response.status).to eq(422)
    end

    it 'rejects a second response from the same user' do
      create(:satisfaction_survey_response, user: user)

      post '/v1/satisfaction_surveys', payload.to_json, headers

      expect(last_response.status).to eq(409)
    end
  end
end
