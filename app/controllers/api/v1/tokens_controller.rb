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

        # Find the client by the client_id and authenticate it
        client = API::Client.find_by_client_id(client_id)

        return halt(401) unless client&.authenticate(client_secret)

        # Create the access token
        access_token = Tokenable.create_jwt(
          payload: { 'sub' => client.client_id }
        )

        status(200)

        {
          access_token: access_token,
          token_type: 'Bearer',
          expires_in: ENV.fetch('SECONDS').to_i # 7 days in minutes
        }.to_json
      end
    end
  end
end
