# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class AnalysisReportsController < ApplicationController
      # POST /api/v1/analysis-reports
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

      # POST /api/v1/analysis-reports/:uuid/retry
      post('/api/v1/analysis-reports/:uuid/retry') do
        analysis_report = find_analysis_report(request, params)

        unless analysis_report.present?
          halt(404, { message: 'Analysis report not found' })
        end

        unless analysis_report.status == 'error'
          halt(400, { message: 'Analysis report must be status error' })
        end

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
