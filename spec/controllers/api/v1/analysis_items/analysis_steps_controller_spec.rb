# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(
  API::V1::AnalysisItems::AnalysisStepsController, type: :controller
) do
  include Rack::Test::Methods

  describe 'POST /api/v1/analysis-items/:analysis_item_id/steps' do
    let(:analysis_item) { create :analysis_item }
    let(:step) { create :analysis_step }
    let(:valid_params) { { analysis_step_id: step.id }.to_json }
    let(:invalid_params) { { analysis_step_id: nil }.to_json }
    let(:route) { "/api/v1/analysis-items/#{analysis_item.id}/steps" }
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
      end

      it 'returns status 422' do
        post(route, valid_params, headers)

        expect(last_response.status).to eq(422)
      end
    end

    context 'when the step is not associated with the analysis item' do
      it 'enqueues the AnalysisStepJob' do
        post(route, valid_params, headers)

        expect(AnalysisStepJob).to have_received(:perform_later).with(
          analysis_item.id, step.id
        )
      end

      it 'returns status 201' do
        post(route, valid_params, headers)

        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request params are invalid' do
      it 'returns status 422' do
        post(route, invalid_params, headers)

        expect(last_response.status).to eq(400)
      end
    end
  end

  # describe 'GET /api/v1/analysis-items/:analysis_item_id/steps' do
  #   let(:analysis_item) { create :analysis_item }
  #   let(:steps) { create_list :analysis_step, 3 }
  #   let(:route) { "/api/v1/analysis-items/#{analysis_item.id}/steps" }
  #   let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
  #   let(:current_client) { create :api_client }
  #   let(:controller_instance) { described_class.new }

  #   before do
  #     allow(Tokenable).to receive_messages(
  #       authenticate_access_token: 200,
  #       current_client: current_client
  #     )
  #   end

  #   context 'when the request is valid' do
  #     let(:disabled_steps) { create_list :analysis_step, 2, :disabled }

  #     it 'returns the serialized analysis steps' do
  #       analysis_item.steps << steps

  #       get(route, {}.to_json, headers)

  #       expected_response = steps.map do |step|
  #         step.serialize_record(with: Analysis::StepSerializer)
  #       end.to_json

  #       expect(last_response.body).to eq(expected_response)
  #     end

  #     it 'returns status 200' do
  #       get(route, {}.to_json, headers)

  #       expect(last_response.status).to eq(200)
  #     end
  #   end

  #   context 'when the analysis item does not exist' do
  #     let(:route) { '/api/v1/analysis-items/999/steps' }

  #     it 'returns status 404' do
  #       get(route, {}.to_json, headers)

  #       expect(last_response.status).to eq(404)
  #     end
  #   end
  # end
end
