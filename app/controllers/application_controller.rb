# frozen_string_literal: true

require_relative 'concerns/tokenable'
require_relative 'concerns/sortable'

class ApplicationController < Sinatra::Base
  before do
    content_type :json
  end
end
