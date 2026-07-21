# frozen_string_literal: true

require_relative 'config/application'

use Rack::CommonLogger, $stdout

run AtivaIdosoApi
