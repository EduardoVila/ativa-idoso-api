# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class Users < Sinatra::Base
    include Validatable
    include Headable

    post('/v1/users') do
      content_type :json

      user_params = JSON.parse(request.body.read)
      permitted_params = user_params.slice('name', 'cpf')
      formatted_cpf = CPF::Formatter.format(permitted_params['cpf'])
      existing_user = User.find_by(cpf: formatted_cpf)

      if existing_user
        status 200
        return existing_user.serialize_record.to_json
      end

      user = User.new(permitted_params)

      if user.save
        status 201

        user.serialize_record.to_json
      else
        status 422

        { errors: user.errors.full_messages }.to_json
      end
    rescue ActiveRecord::RecordNotUnique
      user = User.find_by(cpf: formatted_cpf)

      if user
        status 200
        user.serialize_record.to_json
      else
        status 422
        { errors: ['CPF já cadastrado.'] }.to_json
      end
    end
  end
end
