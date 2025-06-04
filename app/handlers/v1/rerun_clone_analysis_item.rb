# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class RerunCloneAnalysisItem < Sinatra::Base
    include Headable

    post('/v1/analysis-items/:analysis_item_id/reruns') do
      current_client = Tokenable.current_client(request)
      halt(401) if current_client.blank?

      # Find most recent analysis item
      analysis_item = Analysis::Item.find_by(id: params[:analysis_item_id])
      halt(404) if analysis_item.blank?

      verify_client_ownership!(current_client, analysis_item.report)

      # Enqueue job
      RerunCloneAnalysisItemJob.perform_async(analysis_item.id)
      status(202)
    end

    private

    def verify_client_ownership!(client, report)
      halt(403) unless report.api_client_id == client.id
    end
  end
end
