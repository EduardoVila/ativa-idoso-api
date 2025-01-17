# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(
  API::V1::AnalysisItems::RerunsController, type: :controller
) do
  include Rack::Test::Methods

  describe 'POST /api/v1/:analysis_item_id/rerun' do
    let(:analysis_item) { create :analysis_item }
    let(:route) { "/api/v1/#{analysis_item.id}/rerun" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { create :api_client }

    before do
      allow(ClonedAnalysisItemJob).to receive(:perform_later)
      allow(Tokenable).to receive_messages(
        authenticate_access_token: 200,
        current_client: current_client
      )
    end

    context 'when the request is valid' do
      it 'enqueues the ClonedAnalysisItemJob' do
        post(route, {}, headers)

        expect(ClonedAnalysisItemJob).to have_received(:perform_later).with(
          analysis_item.id.to_s
        )
      end

      it 'returns status 201' do
        post(route, {}, headers)

        expect(last_response.status).to eq(201)
      end

      it 'returns a success message' do
        post(route, {}, headers)

        expect(last_response.body).to eq(
          { message: 'Analysis item rerun scheduled' }.to_json
        )
      end
    end

    context 'when the request is invalid' do
      before do
        allow(Tokenable).to receive(:authenticate_access_token).and_return(401)
      end

      it 'returns status 401' do
        post(route, {}, headers)

        expect(last_response.status).to eq(401)
      end
    end
  end
end
