# frozen_string_literal: true

require 'require_all'
require_all 'app/controllers'

class Router
  def self.init(app)
    app.use HealthController
  end
end
