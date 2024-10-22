# frozen_string_literal: true

class HealthController < ApplicationController
  set :base, '/health'

  get '/' do
    status 200

    'Health: OK'
  end
end
