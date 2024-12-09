# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class TokensController < ApplicationController
      post '/api/v1/tokens' do
        # Check if the request is a valid client_credentials request
        if request.env['CONTENT_TYPE'] != 'application/x-www-form-urlencoded' ||
           params['grant_type'] != 'client_credentials' ||
           params['client_id'].nil? ||
           params['client_secret'].nil?
          halt(401)
        end

        begin
          client_id = Base64.strict_decode64(params['client_id'])
          client_secret = Base64.strict_decode64(params['client_secret'])
        rescue ArgumentError
          halt(401)
        end
        # Generate a JWT token
        token = Tokenable.create_access_token(client_id, client_secret)

        # Return the token if it was generated
        if token
          status(200)
          {
            access_token: Base64.strict_encode64(token),
            token_type: 'bearer',
            expires_in: 10_080, # 7 days in minutes
            created_at: Time.now
          }.to_json
        else
          halt(401)
        end
      end
    end
  end
end
