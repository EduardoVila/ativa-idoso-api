# spec/controllers/api/v1/analysis_reports_controller_spec.rb

require 'spec_helper'

RSpec.describe API::V1::AnalysisReportsController, type: :controller do
  include Rack::Test::Methods

  let(:current_client) { create :api_client }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  before do
    allow(Tokenable).to receive_messages(
      authenticate_access_token: true, current_client: current_client
    )
  end

  describe 'GET /api/v1/analysis-reports/:uuid' do
    context 'when the report exists' do
      let!(:analysis_report) do
        create :analysis_report, api_client: current_client
      end

      it 'returns the analysis report' do
        get "/api/v1/analysis-reports/#{analysis_report.id}", {}, headers

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(analysis_report.id)
      end
    end

    context 'when the report does not exist' do
      it 'returns a 404 error' do
        get '/api/v1/analysis-reports/non-existent-uuid', {}, headers

        expect(last_response.status).to eq(404)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to eq('Analysis::Report non-existent-uuid not found')
      end
    end

    context 'when authentication fails' do
      before do
        allow(Tokenable).to receive(:authenticate_access_token).and_return(false)
      end

      it 'returns a 401 Unauthorized error' do
        get '/api/v1/analysis-reports/some-uuid', {}, headers

        expect(last_response.status).to eq(401)
        # You can add more assertions here, such as checking the error message
      end
    end
  end
end
