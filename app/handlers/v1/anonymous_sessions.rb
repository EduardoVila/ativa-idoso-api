# frozen_string_literal: true

require 'securerandom'

module V1
  class AnonymousSessions < Sinatra::Base
    DEVICE_ID_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

    post('/v1/anonymous_sessions') do
      content_type :json

      device_id = request.env['HTTP_X_DEVICE_ID'].to_s.strip
      halt 422, { error: 'A valid X-Device-ID header is required.' }.to_json unless DEVICE_ID_PATTERN.match?(device_id)

      user = User.find_or_initialize_by(device_id: device_id)

      if user.new_record?
        user.assign_attributes(
          name: 'Usuário anônimo',
          anonymous: true
        )
      end

      if user.save
        status(user.previously_new_record? ? 201 : 200)
        user.serialize_record.to_json
      else
        status 422
        { errors: user.errors.full_messages }.to_json
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
