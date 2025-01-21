# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    # AnalysisReportsController handles the creation and retrieval of analysis reports.
    #
    # Routes:
    # - POST /api/v1/analysis-reports: Creates a new analysis report.
    # - GET /api/v1/analysis-reports/:uuid: Retrieves an analysis report by UUID.
    #
    # Before Actions in ApplicationController:
    # - Authenticates access token for the specified routes.
    #
    # Methods:
    # - post('/api/v1/analysis-reports'): Creates a new analysis report with the provided parameters.
    #   - Params:
    #     - analysis_report: Hash containing the analysis report data.
    #       - cpfs [Array of Strings]: CPF number to analyze. Required.
    #     - callback_url [String]: URL to send the webhook event. Required.
    #   - Returns:
    #     - 201 status and serialized analysis report JSON if successful.
    #     - 422 status if the report cannot be saved.
    #
    # - get('/api/v1/analysis-reports/:uuid'): Retrieves an analysis report by UUID.
    #   - Params:
    #     - uuid: UUID of the analysis report.
    #   - Returns:
    #     - 200 status and serialized analysis report JSON if found.
    #     - 404 status if the report is not found.
    class AnalysisReportsController < ApplicationController
      post('/api/v1/analysis-reports') do
        current_client = Tokenable.current_client(request)
        body_params = JSON.parse(request.body.read)

        # Validates the presence of the analysis report and callback URL.
        if body_params['analysis_report'].blank? ||
           body_params['callback_url'] !~ URI::DEFAULT_PARSER.make_regexp # TODO: improve regex
          halt(400, { message: 'Invalid parameters' }.to_json)
        end

        analysis_report = ::Analysis::Report.new(
          **body_params['analysis_report'], api_client_id: current_client&.id
        )

        if analysis_report.save && analysis_report.persisted?
          API::WebhookEvent.create(
            callback_url: body_params['callback_url'],
            event_type: 'analysis_report',
            event_id: analysis_report.id,
            status: 'received',
            access_token: request.env['HTTP_AUTHORIZATION'],
            api_client_id: current_client.id
          )

          AnalysisReportJob.perform_later(analysis_report.id)

          status(201)

          analysis_report.serialize_record.to_json
        else
          halt(422, { message: 'Analysis report could not be saved' }.to_json)
        end
      end

      post('/api/v1/analysis-reports/:uuid/retry') do
        analysis_report = find_analysis_report(request, params)

        return status(404) unless analysis_report.present?

        return status(400) unless analysis_report.status == 'error'

        RetryJob.perform_later(analysis_report.id)

        status(202)
      end

      get('/api/v1/analysis-reports/:uuid') do
        analysis_report = find_analysis_report(request, params)

        if analysis_report.present?
          status(200)

          analysis_report.serialize_record.to_json
        else
          halt(404, { message: 'Analysis report not found' }.to_json)
        end
      end

      private

      def find_analysis_report(request, params)
        current_client = Tokenable.current_client(request)

        ::Analysis::Report.includes(:api_client).find_by(
          id: params[:uuid], api_client_id: current_client.id
        )
      end
    end
  end
end
