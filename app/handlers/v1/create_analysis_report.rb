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
      halt(401, { 'WWW-Authenticate' => 'Bearer' }) if current_client.blank?

      subscriptions = current_client.active_subscriptions
      halt(404, 'No active subscriptions found') if subscriptions.blank?

      # Parse and validate request body
      body_params = ensure_valid_request_body(request)
      data = body_params['data']
      halt(400) if data.blank?

      # Validate required parameters
      halt(400) unless required_params_present?(data)

      # Create analysis report
      report = create_report(data, current_client)
      halt(422) unless report.persisted?

      # For each active subscription create events to track analysis report
      subscriptions.each { |sub| create_event(report, sub, data, current_client) }
      halt(422) if report.api_webhook_events.blank?

      # Enqueue job to process the analysis report
      AnalysisReportJob.perform_async(report.id)

      # Return response with status 201 and send the alpop-analysis-pointer
      status(201)
      report.serialize_record.to_json
    end

    private

    def required_params_present?(params)
      params['cpfs'].present? && params['callback_id'].present?
    end

    def create_report(data, client)
      ::Analysis::Report.new(
        cpfs: data['cpfs'],
        prediction_model_name: data['prediction_model_name'],
        api_client_id: client.id,
        status: :todo
      ).tap(&:save)
    end

    def create_event(report, subscription, data, client)
      Api::WebhookEvent.create(
        callback_id: data['callback_id'],
        event_type: 'analysis_report',
        status: 'received',
        analysis_report: report,
        api_client_id: client.id,
        api_webhook_subscription: subscription
      )
    end
  end
end
