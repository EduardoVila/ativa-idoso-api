# frozen_string_literal: true

module ProScore
  class AuthenticationService < ApplicationService
    def call
      last_authentication = ProScore::Authentication.last

      if last_authentication.blank? || last_authentication.expired?
        authentication = ProScore::AuthenticationIntegrator.new.authenticate

        return authentication.access_token
      end

      last_authentication.access_token
    end
  end
end
