# frozen_string_literal: true

require_relative '../application_service'

module Analyzes
  class TokenService < ApplicationService
    def call
      last_token = ::Analyzes::Token.last

      if last_token.blank? || last_token.expired?
        integrator = Analyzes::TokenIntegrator.new
        token = integrator.create_resource

        return token
      end

      last_token
    end
  end
end
