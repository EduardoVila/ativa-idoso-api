# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(API::V1::AnalysisItemsController, type: :controller) do
  include Rack::Test::Methods

  describe 'POST /api/v1/analysis-items/:analysis_item_id/next-steps' do
    subject(:post_request) { post(route, valid_params, headers) }

    let(:analysis_item) { create :analysis_item }
    let(:step) { create :analysis_step }
    let(:valid_params) { { analysis_step_id: step.id }.to_json }
    let(:invalid_params) { { analysis_step_id: nil }.to_json }
    let(:route) { "/api/v1/analysis-items/#{analysis_item.id}/next-steps" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { create :api_client }

    before do
      allow(AnalysisStepJob).to receive(:perform_later)
      allow(Tokenable).to receive_messages(
        authenticate_access_token: 200,
        current_client: current_client
      )
    end

    context 'when the step is already associated with the analysis item' do
      before do
        analysis_item.steps << step

        post_request
      end

      it 'returns status 422' do
        expect(last_response.status).to eq(422)
      end
    end

    context 'when the step is not associated with the analysis item' do
      before { post_request }

      it 'enqueues the AnalysisStepJob' do
        expect(AnalysisStepJob).to have_received(:perform_later).with(
          analysis_item.id, step.id
        )
      end

      it 'returns status 202' do
        expect(last_response.status).to eq(202)
      end
    end

    context 'when the request params are invalid' do
      let(:post_request) { post(route, invalid_params, headers) }

      it 'returns status 422' do
        post_request

        expect(last_response.status).to eq(400)
      end
    end
  end

  describe 'POST /api/v1/:analysis_item_id/reruns' do
    subject(:post_request) { post(route, {}, headers) }

    let(:analysis_item) { create :analysis_item }
    let(:route) { "/api/v1/#{analysis_item.id}/reruns" }
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
      before { post_request }

      it 'enqueues the ClonedAnalysisItemJob' do
        expect(ClonedAnalysisItemJob).to have_received(:perform_later).with(
          analysis_item.id.to_s
        )
      end

      it 'returns status 202' do
        expect(last_response.status).to eq(202)
      end

      it 'returns a success message' do
        expect(last_response.body).to eq(
          { message: 'Analysis item rerun scheduled' }.to_json
        )
      end
    end

    context 'when the request is invalid' do
      before do
        allow(Tokenable).to receive(:authenticate_access_token).and_return(401)

        post_request
      end

      it 'returns status 401' do
        expect(last_response.status).to eq(401)
      end
    end
  end
end
