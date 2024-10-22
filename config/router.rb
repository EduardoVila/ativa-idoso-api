# frozen_string_literal: true

Dir.glob(File.join(File.dirname(__FILE__),
                   '../app/controllers/*.rb')).each do |file|
  require file
end

class Router
  def self.init(app)
    app.use HealthController

    app.get '/' do
      status 200

      'Welcome to Alpop Analysis API'
    end

    app.not_found do
      status 404

      { error: 'Not Found' }.to_json
    end

    app.error 500 do
      status 500

      { error: 'Internal Server Error' }.to_json
    end
  end
end
