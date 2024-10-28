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
      include Tokenable
      set :base, '/api/v1/tokens'

      post '/' do
        if request.env['CONTENT_TYPE'] != 'application/x-www-form-urlencoded' ||
           params['grant_type'] != 'client_credentials' ||
           params['client_id'].nil? ||
           params['client_secret'].nil?
          halt 401
        end

        token = Tokenable.create_access_token(
          Base64.strict_decode64(params['client_id']),
          Base64.strict_decode64(params['client_secret'])
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
    end
  end
end
