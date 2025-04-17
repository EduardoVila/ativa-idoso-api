# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class RetryAnalysisReport < Sinatra::Base
    include Headable

    post('/v1/analysis-reports/:analysis_report_id/retries') do
      current_client = Tokenable.current_client(request)
      halt(401) if current_client.blank?

      # Find most recent analysis item
      analysis_report = Analysis::Report.find_by(
        id: params[:analysis_report_id], api_client_id: current_client.id
      )
      halt(404) if analysis_report.blank?

      # Enqueue retry job
      RetryFailedAnalysisItemsJob.perform_later(analysis_report.id)
      status(202)
    end
  end
end
