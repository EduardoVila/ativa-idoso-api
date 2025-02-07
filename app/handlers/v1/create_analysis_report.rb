# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class CreateAnalysisReport < Sinatra::Base
    include Validatable
    include Headable

    post('/v1/analysis-reports') do
      current_client = Tokenable.current_client(request)
      halt(401) if current_client.blank?

      # Parse and validate request body
      body_params = ensure_valid_request_body(request)
      data = body_params['data']
      halt(400) if data.blank?

      # Validate required parameters
      cpfs = data['cpfs']
      callback_url = data['callback_url']
      callback_id = data['callback_id']
      halt(400) if cpfs.blank? ||
                   callback_id.blank? ||
                   callback_url !~ URI::DEFAULT_PARSER.make_regexp

      # Create analysis report
      analysis_report = create_analysis_report(cpfs, current_client)
      halt(422) unless analysis_report.persisted?

      # Create webhook and enqueue job
      create_webhook_event(analysis_report, current_client, request, data)
      AnalysisReportJob.perform_later(analysis_report.id)

      # Return response
      status(201)
      analysis_report.serialize_record.to_json
    end

    private

    def create_analysis_report(params, client)
      ::Analysis::Report.new(cpfs: params, api_client_id: client.id).tap(&:save)
    end

    def create_webhook_event(report, client, request, data)
      API::WebhookEvent.create(
        callback_url: data['callback_url'],
        callback_id: data['callback_id'],
        event_type: 'analysis_report',
        event_id: report.id,
        status: 'received',
        access_token: request.env['HTTP_AUTHORIZATION'],
        api_client_id: client.id
      )
    end
  end
end
