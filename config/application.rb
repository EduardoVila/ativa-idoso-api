# frozen_string_literal: true

# This is the main application file that will be used to start the application

require_relative 'environments'

%i[
  load_gems
  load_app
].each { |method| ApplicationLoader.public_send(method) }

# Start the application
class AtivaIdosoApi < Sinatra::Base
  use Rack::Cors do
    allow do
      origins '*'
      resource '*',
               headers: :any,
               methods: %i[get post put patch delete options head],
               expose: %w[Authorization],
               max_age: 600
    end
  end

  # Endpoint handlers
  use V1::Authenticate
  use V1::Users
  use V1::Researches
  use V1::Videos
  use V1::SatisfactionSurveys

  # Health check endpoint
  get '/' do
    headers 'Content-Type' => 'application/json'
    { message: 'Ativa Idoso API is running.' }.to_json
  end
end
