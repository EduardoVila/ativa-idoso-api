# frozen_string_literal: true

namespace :db do
  desc 'Create an API client'
  task create_api_client: :environment do
    require 'securerandom'
    require 'colorize'
    require_relative '../../config/application'

    puts 'Running rake: create_api_client.rake'.magenta.bold
    puts 'Creating API client...'.green.bold
    puts 'The client_id and client_secret will be logged to the console'.cyan
    puts 'The client_secret is hashed before saving it to the database'.cyan
    puts 'client_id and client_secret must be used in strict_base64 encode'.cyan
    puts 'Use these credentials to authenticate with the API'.cyan

    client = Api::Client.create

    if client.save
      puts "API client created with the following uuid: #{client.id}".yellow.bold
    else
      puts 'API client creation failed'.red.bold
      puts client.errors.full_messages
    end
  end
end
