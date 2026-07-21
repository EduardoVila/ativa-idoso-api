# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class Authenticate < Sinatra::Base
    include Headable
    include Authenticable

    post '/v1/authenticate' do
      current_user = User.find_by(cpf: CPF::Formatter.format(params[:cpf]))

      halt(401) if current_user.nil?

      content_type :json

      status 200

      current_user.serialize_record.to_json
    end
  end
end
