# frozen_string_literal: true

require 'json'

module Parseable
  extend ActiveSupport::Concern

  def parser(body)
    JSON.parse(body)
  rescue JSON::ParserError
    nil
  end
end
