# frozen_string_literal: true

require_relative '../application_service'

module Analysis
  class TokenService < ApplicationService
    def call
      last_token = ::Analysis::Token.last

      if last_token.blank? || last_token.expired?
        integrator = Analysis::TokenIntegrator.new
        token = integrator.create_resource

        return token
      end

      last_token
    end
  end
end
