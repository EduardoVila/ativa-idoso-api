# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

RSpec.describe V1::CreateAnalysisReport, type: :handler do
  describe 'POST /v1/analysis-reports' do
    subject(:post_request) { post(route, params.to_json, headers) }

    let(:cpf) { Faker::CPF.numeric }
    let(:route) { '/v1/analysis-reports' }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:current_client) { create :api_client }
    let!(:webhook_credential) do
      create :api_webhook_credential, api_client: current_client
    end
    let(:params) do
      {
        data: {
          cpfs: [cpf.to_s],
          callback_url: 'http://example.test/callback',
          callback_id: '123',
          prediction_model: 'model_name'
        }
      }
    end

    before do
      allow(Tokenable).to receive_messages(current_client: current_client)
      allow(AnalysisReportJob).to receive(:perform_async)
    end

    context 'when the request is valid' do
      before { post_request }

      it 'creates an analysis report' do
        expect(last_response.status).to eq(201)
      end

      it 'returns the correct status in response body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['status']).to eq('todo')
      end

      it 'enqueues the AnalysisReportJob' do
        expect(AnalysisReportJob).to have_received(:perform_async)
      end
    end

    context 'when authentication fails' do
      before do
        allow(Tokenable).to receive(:current_client).and_return(nil)
        post_request
      end

      it 'returns status 401' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when params are invalid' do
      shared_examples 'returns bad request' do
        it 'returns status 400' do
          post_request

          expect(last_response.status).to eq(400)
        end
      end

      context 'with empty cpfs' do
        let(:params) do
          {
            data: {
              cpfs: [],
              callback_url: 'http://example.test/callback',
              callback_id: '123',
              prediction_model: 'model_name'
            }
          }
        end

        it_behaves_like 'returns bad request'
      end

      context 'with invalid callback_url' do
        let(:params) do
          {
            data: {
              cpfs: ['12345678901'],
              callback_url: 'invalid_url',
              callback_id: '123',
              prediction_model: 'model_name'
            }
          }
        end

        it_behaves_like 'returns bad request'
      end

      context 'with blank callback_id' do
        let(:params) do
          {
            data: {
              cpfs: ['12345678901'],
              callback_url: 'http://example.test/callback',
              callback_id: '',
              prediction_model: 'model_name'
            }
          }
        end

        it_behaves_like 'returns bad request'
      end
    end
  end
end
