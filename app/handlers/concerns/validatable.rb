# frozen_string_literal: true

module Validatable
  module_function

  def ensure_valid_request_body(request)
    body = request.body.read
    halt(400) if body.blank?
    request.body.rewind
    JSON.parse(body)
  rescue JSON::ParserError
    halt(400)
  end
end
