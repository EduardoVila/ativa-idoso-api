# frozen_string_literal: true

require 'securerandom'
require 'colorize'
require_relative '../config/application'

puts 'Running script: create_api_client.rb'.magenta.bold
puts 'Creating API client...'.green.bold
puts 'The client_id and client_secret will be logged to the console'.cyan
puts 'The client_secret will be hashed before saving it to the database'.cyan
puts 'The client_id and client_secret will be encoded in strict base64'.cyan
puts 'Use these credentials to authenticate with the API'.cyan

client = API::Client.create

if client.save
  puts "API client created with ID: #{client.id}".yellow.bold
else
  puts 'API client creation failed'.red.bold
  puts client.errors.full_messages
end
