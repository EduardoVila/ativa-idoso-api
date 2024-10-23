# frozen_string_literal: true

class HealthController < ApplicationController
  set :base, '/'

  get '/' do
    status 200

    'Health: OK'
  end
end
