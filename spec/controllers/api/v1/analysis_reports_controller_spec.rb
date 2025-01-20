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
    let(:params) do
      {
        analysis_report: analysis_report_params,
        callback_url: Faker::Internet.url
      }
    end
    let(:job_double) { instance_double(AnalysisReportJob) }

    context 'when the request is successful' do
      before do
        allow(Tokenable).to receive_messages(
          authenticate_access_token: 200,
          current_client: current_client
        )

        allow(AnalysisReportJob).to receive(:perform_later)
          .and_return(job_double)
        allow(API::WebhookEvent).to receive(:create)
        allow(job_double).to receive(:job_id).and_return('1234')
      end

      it 'returns a 201 Created status' do
        post(route, params.to_json, headers)

        expect(last_response.status).to eq(201)
        expect(AnalysisReportJob).to have_received(:perform_later)
        expect(API::WebhookEvent).to have_received(:create)
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

    context 'when the request is invalid' do
      before do
        allow(Tokenable).to receive_messages(
          authenticate_access_token: 200,
          current_client: current_client
        )
      end

      it 'returns a 400 Bad Request status' do
        post(route, {}.to_json, headers)

        expect(last_response.status).to eq(400)
      end
    end
  end

  describe 'POST /api/v1/analysis-reports/:uuid/retry' do
    let!(:analysis_report) do
      create :analysis_report, :error, api_client: current_client
    end
    let(:route) { "/api/v1/analysis-reports/#{analysis_report.id}/retry" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { create :api_client }

    before do
      allow(Tokenable).to receive_messages(
        authenticate_access_token: 200,
        current_client: current_client
      )
      allow(RetryJob).to receive(:perform_later)
    end

    context 'when analysis report exists and status is error' do
      it 'schedules the RetryJob' do
        post(route, {}, headers)

        expect(RetryJob).to have_received(:perform_later)
          .with(analysis_report.id)
      end

      it 'returns a 202 status code' do
        post(route, {}, headers)

        expect(last_response.status).to eq(202)
      end
    end

    context 'when analysis report is not found' do
      let(:route) { '/api/v1/analysis-reports/invalid-uuid/retry' }

      it 'returns a 404 status code' do
        post(route, {}, headers)

        expect(last_response.status).to eq(404)
      end
    end

    context 'when analysis report status is not error' do
      let(:analysis_report) do
        create :analysis_report, :done, api_client: current_client
      end

      it 'returns a 400 status code' do
        post(route, {}, headers)

        expect(last_response.status).to eq(400)
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
