# frozen_string_literal: true

require_relative 'concerns/nestable'
require_relative 'concerns/integrable'
require_relative 'concerns/parseable'

class ApplicationIntegrator
  include Parseable
  include Integrable
  include Nestable
end
