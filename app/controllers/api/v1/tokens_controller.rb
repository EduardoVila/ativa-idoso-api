# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'base64'
require_relative '../../concerns/tokenable'
require_relative '../../application_controller'

module API
  module V1
    class TokensController < ApplicationController
      include Tokenable
      set :base, '/api/v1/tokens'

      post '/' do
        decoded_client_id = Base64.strict_decode64(params['client_id'])
        decoded_client_secret = Base64.strict_decode64(params['client_secret'])

        return halt 401 if params['grant_type'] != 'client_credentials'

        if request.env['CONTENT_TYPE'] != 'application/x-www-form-urlencoded'
          return halt 401
        end

        token = Tokenable.authenticate_client(
          decoded_client_id, decoded_client_secret
        )

        if token
          status 200
          {
            access_token: token,
            token_type: 'bearer',
            expires_in: 3600,
            created_at: Time.now
          }.to_json
        else
          halt 401
        end
      end

      get '/' do
        http_status = Tokenable.authenticate_token(request)
        return halt http_status unless http_status == 200
      end
    end
  end
end
