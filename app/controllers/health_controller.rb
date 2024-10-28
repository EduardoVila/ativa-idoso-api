# frozen_string_literal: true

class HealthController < ApplicationController
  set :base, '/'

  get '/' do
    status 200

    'Health: OK'
  end

  get '/protected' do
    http_status = Tokenable.authenticate_token(request)
    return halt http_status unless http_status == 200

    status 200

    'Protected health: OK'
  end
end
