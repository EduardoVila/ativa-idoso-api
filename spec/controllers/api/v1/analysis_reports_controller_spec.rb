# frozen_string_literal: true

# spec/controllers/api/v1/analysis_reports_controller_spec.rb

require 'spec_helper'

RSpec.describe API::V1::AnalysisReportsController, type: :controller do
  include Rack::Test::Methods

  describe 'POST /api/v1/analysis-reports' do
    let(:route) { '/api/v1/analysis-reports' }
    let(:current_client) { create :api_client }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:analysis_report) { create :analysis_report }
    let(:analysis_report_params) { attributes_for :analysis_report }
    let(:params) { { analysis_report: analysis_report_params } }

    context 'when the request is successful' do
      before do
        allow(Tokenable).to receive_messages(
          authenticate_access_token: 200,
          current_client: current_client
        )
      end

      it 'returns a 201 Created status' do
        post(route, params.to_json, headers)

        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is unsuccessful' do
      before do
        allow(Tokenable).to receive_messages(authenticate_access_token: 401)
      end

      it 'returns a 401 Unauthorized status' do
        post(route, {}.to_json, headers)

        expect(last_response.status).to eq(401)
      end
    end
  end

  describe 'GET /api/v1/analysis-reports/:uuid' do
    let(:base_route) { '/api/v1/analysis-reports' }
    let(:current_client) { create :api_client }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:analysis_report) do
      create :analysis_report, api_client: current_client
    end

    context 'when the report exists' do
      before do
        allow(Tokenable).to receive_messages(
          authenticate_access_token: 200,
          current_client: current_client
        )
      end

      it 'returns the analysis report' do
        get("#{base_route}/#{analysis_report.id}", {}, headers)

        expect(last_response.status).to eq(200)

        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(analysis_report.id)
      end
    end

    context 'when the report does not exist' do
      before do
        allow(Tokenable).to receive_messages(
          authenticate_access_token: 200,
          current_client: current_client
        )
      end

      it 'returns a 404 error' do
        get("#{base_route}/foo", {}, headers)

        expect(last_response.status).to eq(404)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to eq('Analysis report foo not found')
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
