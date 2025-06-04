# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::NextAnalysisStep, type: :handler do
  include Rack::Test::Methods

  describe 'POST /v1/analysis-items/:analysis_item_id/next-steps' do
    subject(:post_request) { post(route, valid_params, headers) }

    let(:analysis_item) { create :analysis_item }
    let(:id) { analysis_item.id }
    let(:analysis_step) { create :analysis_step }
    let(:valid_params) do
      { data: { step_name: analysis_step.name } }.to_json
    end
    let(:invalid_params) { { data: { step_name: nil } }.to_json }
    let(:route) { "/v1/analysis-items/#{id}/next-steps" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { analysis_item.report.api_client }

    before do
      allow(NextAnalysisStepJob).to receive(:perform_async)
      allow(Tokenable).to receive_messages(current_client: current_client)
    end

    context 'when the step is not associated with the analysis item' do
      before { post_request }

      it 'enqueues the NextAnalysisStepJob' do
        expect(NextAnalysisStepJob).to have_received(:perform_async).with(
          analysis_item.id, analysis_step.id
        )
      end

      it 'returns status 202' do
        expect(last_response.status).to eq(202)
      end
    end

    context 'when the step is already associated with the analysis item' do
      before do
        analysis_item.steps << analysis_step

        post_request
      end

      it 'returns status 422' do
        expect(last_response.status).to eq(422)
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
end
