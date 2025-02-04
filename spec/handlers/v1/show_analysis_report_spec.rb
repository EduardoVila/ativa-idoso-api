# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::ShowAnalysisReport, type: :handler do
  describe 'GET /v1/analysis-reports/:uuid' do
    let(:base_route) { '/v1/analysis-reports' }
    let(:current_client) { create :api_client }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:analysis_report) do
      create :analysis_report, api_client: current_client
    end

    context 'when the report exists' do
      before do
        allow(Tokenable).to receive_messages(current_client: current_client)

        get("#{base_route}/#{analysis_report.id}", {}, headers)
      end

      it 'returns the analysis report' do
        expect(last_response.status).to eq(200)

        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(analysis_report.id)
      end
    end

    context 'when the report does not exist' do
      before do
        allow(Tokenable).to receive_messages(current_client: current_client)

        get("#{base_route}/foo", {}, headers)
      end

      it 'returns a 404 error' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'when authentication fails' do
      it 'returns a 401 Unauthorized error' do
        get("#{base_route}/some-uuid", {}, headers)

        expect(last_response.status).to eq(401)
      end
    end
  end
end
