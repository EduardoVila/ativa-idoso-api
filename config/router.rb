# frozen_string_literal: true

# This is the router file that will be used to define the application routes

require 'require_all'
require_all 'app/controllers'

class Router
  def self.init(app)
    app.use HealthController
  end
end
