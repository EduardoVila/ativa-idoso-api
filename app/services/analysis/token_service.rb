# frozen_string_literal: true

require_relative '../application_service'

module Analysis
  class TokenService < ApplicationService
    attr_reader :last_token

    def call
      @last_token = ::Analysis::Token.last

      if last_token.blank? || last_token.expired?
        integrator = Integrators::Analysis::Token.new
        token = integrator.post_request
        return token
      end

      last_token
    end
  end
end
