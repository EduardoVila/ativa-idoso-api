# frozen_string_literal: true

class HealthController < ApplicationController
  # This is a protected endpoint that requires a valid access token (Bearer)
  # to be passed in the Authorization header of the request.
  # If the token is valid, it will return a status 200 with a message.
  # ApplicationController will authenticate the access token before the request is processed.
  get '/protected' do
    status 200
    { message: 'Protected health: OK' }.to_json
  end
end
