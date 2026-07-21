# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

%i[
  load_gems
  load_app
].each { |method| ApplicationLoader.public_send(method) }

# Start the application
class AtivaIdosoApi < Sinatra::Base
  # Endpoint handlers
  use V1::Authenticate
  use V1::Users
  use V1::Researches
  use V1::Videos

  # Health check endpoint
  get '/' do
    headers 'Content-Type' => 'application/json'
    { message: 'Analysis API is running.' }.to_json
  end
end
