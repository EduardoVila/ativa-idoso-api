# frozen_string_literal: true

module Authenticable
  module_function

  def current_user(request)
    auth_header = request.env['HTTP_AUTHORIZATION']

    return if auth_header.blank?

    User.find_by(access_token: auth_header)
  end
end
