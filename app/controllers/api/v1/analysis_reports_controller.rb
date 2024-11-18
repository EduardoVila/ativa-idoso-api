# frozen_string_literal: true

require_relative '../../application_controller'
require_relative '../../../../app/controllers/api/v1/analysis_reports_controller'

module API
  module V1
    class AnalysisReportsController < ApplicationController
      before(%w[/api/v1/analysis-reports /api/v1/analysis-reports/:uuid]) do
        authenticate_access_token_from request
      end

      post '/api/v1/analysis-reports' do
        analysis_report = ::Analysis::Report.new(params[:analysis_report])

        analysis_report.api_client_id = Tokenable.current_client(request).id

        if analysis_report.save && analysis_report.persisted?
          status 201
          analysis_report.to_json # TODO: Refactor to use a serializer
        else
          status 422
        end
      end

      get '/api/v1/analysis-reports/:uuid' do
        report = ::Analysis::Report.includes(:api_client).find_by(
          id: params[:uuid], api_client_id: Tokenable.current_client(request).id
        )

        if report.present?
          status 200
          report.to_json # TODO: Refactor to use a serializer
        else
          halt 404,
               { error: "Analysis::Report #{params[:uuid]} not found" }.to_json
        end
      end
    end
  end
end
