# frozen_string_literal: true

require_relative 'concerns/tokenable'
require_relative 'concerns/sortable'

class ApplicationController < Sinatra::Base
  include Tokenable

  before do
    content_type :json
  end

  # Protects the following endpoints with a valid access token.
  before(%w[
    /protected
    /api/v1/analysis-reports
    /api/v1/analysis-reports/:uuid/retries
    /api/v1/analysis-reports/:uuid
    /api/v1/analysis-items/:analysis_item_id/next-steps
    /api/v1/analysis-items/:analysis_item_id/reruns
  ]) { authenticate_access_token_from(request) }

  def authenticate_access_token_from(request)
    http_status = Tokenable.authenticate_access_token(request)
    halt(http_status) unless http_status == 200
    http_status
  end
end
