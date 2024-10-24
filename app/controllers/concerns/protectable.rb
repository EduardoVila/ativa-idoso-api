# frozen_string_literal: true

require_relative 'tokenable'
require 'sinatra'

module Protectable
  include Tokenable

  private

  def authorization_header
    authorization_header = request.headers['Authorization']

    authorization_header&.split&.last
  end

  def decoded_authorization_token
    jwt_decode(authorization_header)
  end

  def current_user
    @current_user = API::Client.find(decoded_authorization_token[:api_client_id])
  rescue NoMethodError
    head :forbidden
  end

  def authenticate_request
    current_user
  rescue JWT::ExpiredSignature, JWT::DecodeError
    head :forbidden
  end
end
