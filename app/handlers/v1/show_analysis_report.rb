# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class ShowAnalysisReport < Sinatra::Base
    include Headable

    get('/v1/analysis-reports/:uuid') do
      current_client = Tokenable.current_client(request)

      halt(401) if current_client.blank?

      analysis_report = ::Analysis::Report.includes(:api_client).find_by(
        id: params[:uuid], api_client_id: current_client.id
      )

      halt(404) unless analysis_report.present?

      status(200)
      analysis_report.serialize_record.to_json
    end
  end
end
