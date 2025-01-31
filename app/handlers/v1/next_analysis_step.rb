# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class NextAnalysisStep < Sinatra::Base
    include Validatable

    post('/v1/analysis-items/:analysis_item_id/next-steps') do
      current_client = Tokenable.current_client(request)
      halt(401) if current_client.blank?

      # Parse and validate request body
      body_params = ensure_valid_request_body(request)
      step_id = body_params['analysis_step_id']
      halt(400) if step_id.blank?

      # Find analysis item by ID
      analysis_item = Analysis::Item.find_by(id: params[:analysis_item_id])
      halt(404) if analysis_item.blank?

      verify_client_ownership!(current_client, analysis_item.report)

      # Validate step hasn't been processed
      halt(422) if analysis_item.steps.exists?(id: step_id)

      # Enqueue job
      AnalysisStepJob.perform_later(analysis_item.id, step_id)
      status(202)
    end

    private

    def verify_client_ownership!(client, report)
      halt(403) unless report.api_client_id == client.id
    end
  end
end
