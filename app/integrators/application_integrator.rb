# frozen_string_literal: true

require 'json'

require_relative 'concerns/nestable'
require_relative 'concerns/integrable'
require_relative '../handlers/concerns/tokenable'

class ApplicationIntegrator
  include Integrable
  include Nestable

  def json_parse(body)
    JSON.parse(body)
  rescue JSON::ParserError
    nil
  end
end
