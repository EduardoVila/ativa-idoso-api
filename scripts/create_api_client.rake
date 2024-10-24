# frozen_string_literal: true

require 'securerandom'
require_relative '../config/application'

client_id = SecureRandom.hex(32)
client_secret = SecureRandom.hex(32)

client = API::Client.new(client_id: client_id, client_secret: client_secret)

if client.save
  puts(
    "Database populated with new client:\n" \
    "client_id: #{client_id}\n" \
    "client_secret: #{client_secret}"
  )
end
