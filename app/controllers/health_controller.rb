# frozen_string_literal: true

class HealthController < ApplicationController
  set :base, '/'

  get '/' do
    status 200
    { message: 'Health: OK' }.to_json
  end

  # Before filter to authenticate the access token from the request.
  # This will be called before the '/protected' endpoint is called.
  # Usage: before '<endpoint>' { authenticate_access_token_from request }
  before('/protected') { authenticate_access_token_from request }

  # This is a protected endpoint that requires a valid access token (Bearer)
  # to be passed in the Authorization header of the request.
  get '/protected' do
    status 200
    { message: 'Protected health: OK' }.to_json
  end
end
