# frozen_string_literal: true

require 'sinatra'
require 'rack/protection'

module Headable
  extend ActiveSupport::Concern

  included do
    before do
      headers 'Content-Type' => 'application/json'
    end
  end
end
