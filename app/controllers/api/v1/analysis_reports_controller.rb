# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class AnalysisReportsController < ApplicationController
      before(%w[/api/v1/analysis-reports /api/v1/analysis-reports/:uuid]) do
        authenticate_access_token_from request
      end

      post('/api/v1/analysis-reports') do
        current_client = Tokenable.current_client(request)
        body_params = JSON.parse(request.body.read)

        analysis_report = ::Analysis::Report.new(body_params['analysis_report'])
        analysis_report.api_client_id = current_client&.id

        if analysis_report.save && analysis_report.persisted? # TODO: Refactor to add save_and_run method to run job
          status 201

          analysis_report.to_json # TODO: Refactor to use a serializer
        else
          status 422
        end
      end

      get('/api/v1/analysis-reports/:uuid') do
        current_client = Tokenable.current_client(request)

        report = ::Analysis::Report.includes(:api_client).find_by(
          id: params[:uuid], api_client_id: current_client.id
        )

        if report.present?
          status 200

          report.to_json # TODO: Refactor to use a serializer
        else
          halt 404,
               { error: "Analysis report #{params[:uuid]} not found" }.to_json
        end
      end
    end
  end
end
