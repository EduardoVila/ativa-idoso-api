# frozen_string_literal: true

require 'sinatra'
require 'rack/protection'

module Headable
  extend ActiveSupport::Concern

  included do
    before do
      headers 'X-Content-Type-Options' => 'nosniff',
              'X-Frame-Options' => 'DENY',
              'X-XSS-Protection' => '1; mode=block',
              'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains', # rubocop:disable Layout/LineLength,Lint/RedundantCopDisableDirective
              'Referrer-Policy' => 'no-referrer',
              'Content-Type' => 'application/json'
    end
  end
end
