# frozen_string_literal: true

require 'spec_helper'

RSpec.describe V1::RetryAnalysisReport, type: :handler do
  describe 'POST /v1/analysis-reports/:analysis_report_id/retries' do
    subject(:post_request) { post(route, params, headers) }

    let!(:analysis_report) do
      create :analysis_report, :error, api_client: current_client
    end
    let!(:analysis_item) { create :analysis_item, report: analysis_report }
    let(:id) { analysis_report.id }
    let(:route) { "/v1/analysis-reports/#{id}/retries" }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { create :api_client }
    let(:params) { {} }

    before do
      allow(Tokenable).to receive_messages(current_client: current_client)
      allow(RetryJob).to receive(:perform_later)

      post_request
    end

    context 'when analysis report exists and status is error' do
      it 'schedules the RetryJob' do
        expect(RetryJob).to have_received(:perform_later)
          .with(analysis_report.id)
      end

      it 'returns a 202 status code' do
        expect(last_response.status).to eq(202)
      end
    end

    context 'when analysis report is not found' do
      let(:route) { '/api/v1/analysis-reports/retries' }

      before do
        allow(Tokenable).to receive_messages(current_client: current_client)
        allow(RetryJob).to receive(:perform_later)

        post(route, { cpf: '00000000000' }.to_json, headers)
      end

      it 'returns a 404 status code' do
        post_request

        expect(last_response.status).to eq(404)
      end
    end
  end
end
