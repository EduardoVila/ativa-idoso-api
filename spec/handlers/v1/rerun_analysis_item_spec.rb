# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::RerunAnalysisItem, type: :handler do
  describe 'POST /v1/analysis-items/:analysis_item_id/reruns' do
    subject(:post_request) { post(route, headers) }

    let(:analysis_item) { create :analysis_item }
    let(:id) { analysis_item.id }
    let(:route) { "/v1/analysis-items/#{id}/reruns" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { analysis_item.report.api_client }

    before do
      allow(ClonedAnalysisItemJob).to receive(:perform_later)
      allow(Tokenable).to receive_messages(current_client: current_client)
    end

    context 'when the request is valid' do
      before { post_request }

      it 'enqueues the ClonedAnalysisItemJob' do
        expect(ClonedAnalysisItemJob).to have_received(:perform_later).with(
          analysis_item.id
        )
      end

      it 'returns status 202' do
        expect(last_response.status).to eq(202)
      end
    end

    context 'when the request is invalid' do
      before do
        allow(Tokenable).to receive(:current_client).and_return(nil)

        post_request
      end

      it 'returns status 401' do
        expect(last_response.status).to eq(401)
      end
    end
  end
end
