# frozen_string_literal: true

# This is the router file that will be used to define the application routes

require 'sinatra'
require 'require_all'
require_all 'app/controllers'

class Router < Sinatra::Base
  def self.init(app)
    app.use HealthController
    app.use API::V1::TokensController
  end
end
