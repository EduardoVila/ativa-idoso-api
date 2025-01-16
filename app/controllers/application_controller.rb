# frozen_string_literal: true

require_relative 'concerns/tokenable'
require_relative 'concerns/sortable'

class ApplicationController < Sinatra::Base
  before { content_type :json }

  def authenticate_access_token_from(request)
    http_status = Tokenable.authenticate_access_token(request)
    halt http_status unless http_status == 200
  end
end
