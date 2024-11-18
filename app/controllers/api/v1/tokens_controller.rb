# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'base64'
require_relative '../../application_controller'

module API
  module V1
    class TokensController < ApplicationController
      # Endpoint to generate a JWT token when a client authenticates with
      # client_id and client_secret credentials.
      include Tokenable

      before do
        @content_type = request.env['CONTENT_TYPE']
        @grant_type = params['grant_type']
        @client_id = params['client_id']
        @client_secret = params['client_secret']
      end

      post '/api/v1/tokens' do
        # Check if the request is a valid client_credentials request
        if @content_type != 'application/x-www-form-urlencoded' ||
           @grant_type != 'client_credentials' ||
           @client_id.nil? ||
           @client_secret.nil?
          halt 401
        end

        # Generate a JWT token
        token = Tokenable.create_access_token(
          Base64.strict_decode64(@client_id),
          Base64.strict_decode64(@client_secret)
        )

        # Return the token if it was generated
        if token
          status 200
          {
            access_token: Base64.strict_encode64(token),
            token_type: 'bearer',
            expires_in: 10_080, # 7 days in minutes
            created_at: Time.now
          }.to_json
        else
          halt 401
        end
      end
    end
  end
end
