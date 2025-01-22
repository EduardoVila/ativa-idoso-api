# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'base64'
require_relative 'concerns/tokenable'

class ApplicationController < Sinatra::Base
  include Tokenable

  before do
    content_type :json
    authenticate_access_token_from(request)
  end

  def authenticate_access_token_from(request)
    http_status = Tokenable.authenticate_access_token(request)
    halt(http_status) unless http_status == 200
    http_status
  end
end
