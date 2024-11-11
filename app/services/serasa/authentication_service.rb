# frozen_string_literal: true

require_relative '../application_service'

module Serasa
  class AuthenticationService < ApplicationService
    def call
      last_authentication = Serasa::Authentication.last

      if last_authentication.blank? || last_authentication.expired?
        integrator = Serasa::AuthenticationIntegrator.new
        authentication = integrator.authenticate

        return authentication.access_token
      end

      last_authentication.access_token
    end
  end
end
