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
      halt(400) unless required_params_present?(data)

      # Create analysis report
      analysis_report = create_analysis_report(data, current_client)
      halt(422) unless analysis_report.persisted?

      # Check if the client has a webhook credential
      halt(422) if current_client.api_webhook_credentials.blank?

      # Create webhook event to track the analysis report
      credential = current_client.api_webhook_credentials.first
      create_webhook_event(analysis_report, credential, data)

      # Enqueue job to process the analysis report
      AnalysisReportJob.perform_async(analysis_report.id)

      # Return response with status 201 and send the alpop-analysis-pointer
      status(201)
      analysis_report.serialize_record.to_json
    end

    private

    def required_params_present?(params)
      params['cpfs'].present? &&
        params['callback_url'].present? &&
        params['callback_id'].present? &&
        params['callback_url'] =~ URI::DEFAULT_PARSER.make_regexp
    end

    def create_analysis_report(data, client)
      ::Analysis::Report.new(
        cpfs: data['cpfs'],
        prediction_model_name: data['prediction_model_name'],
        api_client_id: client.id,
        status: :todo
      ).tap(&:save)
    end

    def create_webhook_event(report, credential, data)
      Api::WebhookEvent.create(
        callback_url: data['callback_url'],
        callback_id: data['callback_id'],
        event_type: 'analysis_report',
        status: 'received',
        analysis_report: report,
        api_webhook_credential: credential
      )
    end
  end
end
