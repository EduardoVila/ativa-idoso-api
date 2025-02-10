# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class Authenticate < Sinatra::Base
    include Headable

    post '/v1/authenticate' do
      # Validate request format and parameters
      halt(401) unless valid_token_request?(request, params)

      # Decode and validate credentials
      credentials = decode_credentials(params)
      halt(401) if credentials.nil?

      # Authenticate client
      client = authenticate_client(credentials)
      halt(401) unless client

      # Generate token and response
      tokenable_response(client)
    end

    private

    def valid_token_request?(request, params)
      request.env['CONTENT_TYPE'] == 'application/x-www-form-urlencoded' &&
        params['grant_type'] == 'client_credentials' &&
        params['client_id'].present? &&
        params['client_secret'].present?
    end

    def decode_credentials(params)
      {
        client_id: Base64.strict_decode64(params['client_id']),
        client_secret: Base64.strict_decode64(params['client_secret'])
      }
    rescue ArgumentError
      nil
    end

    def authenticate_client(credentials)
      client = API::Client.find_by_client_id(credentials[:client_id])
      client&.authenticate(credentials[:client_secret]) ? client : nil
    end

    def tokenable_response(client)
      access_token = Tokenable.create_jwt(
        payload: { 'sub' => client.client_id }
      )

      status(200)
      {
        access_token: access_token,
        token_type: 'Bearer',
        expires_in: ENV.fetch('SECONDS').to_i
      }.to_json
    end
  end
end
