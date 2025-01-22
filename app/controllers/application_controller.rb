# frozen_string_literal: true

require_relative 'concerns/tokenable'
require_relative 'concerns/sortable'

class ApplicationController < Sinatra::Base
  include Tokenable

  before do
    content_type :json

    unless instance_of?(API::V1::TokensController)
      authenticate_access_token_from(request)
    end
  end

  def authenticate_access_token_from(request)
    http_status = Tokenable.authenticate_access_token(request)
    halt(http_status) unless http_status == 200
    http_status
  end
end
