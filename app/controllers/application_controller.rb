# frozen_string_literal: true

require 'sinatra/base'

class ApplicationController < Sinatra::Base
  before do
    content_type :json
    request.path_info =
      "/#{request.path_info.sub(%r{\A/?#{settings.base}}, '')}"
  end
end
