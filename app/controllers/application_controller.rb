# frozen_string_literal: true

require 'sinatra'
require_relative 'concerns/tokenable'

class ApplicationController < Sinatra::Base
  before do
    content_type :json
    request.path_info =
      "/#{request.path_info.sub(%r{\A/?#{settings.base}}, '')}"
  end

  def authenticate_access_token_from(request)
    http_status = Tokenable.authenticate_access_token(request)
    halt http_status unless http_status == 200
  end
end
