# frozen_string_literal: true

require_relative 'application_controller'

class HealthController < ApplicationController
  # This is a protected endpoint that requires a valid access token (Bearer jwt)
  # to be passed in the Authorization header of the request.
  # If the token is valid, it will return a status 200 with a message.

  get '/protected' do
    current_client = Tokenable.current_client(request)

    halt(401) if current_client.blank?

    status(200)
  end
end
