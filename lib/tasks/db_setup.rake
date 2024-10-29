# frozen_string_literal: true

require 'dotenv/load'
require 'byebug'
Dotenv.load('.env')

namespace :db do
  desc 'Drop, create and migrate database for test environment'
  task :restart_db_test do
    # rubocop:disable Layout/LineLength
    system('APP_ENV=test bundle exec rake db:environment:set db:drop db:create db:migrate')
    # rubocop:enable Layout/LineLength
  end

  desc 'Drop, create and migrate database for development environment'
  task :restart_db_development do
    # rubocop:disable Layout/LineLength
    system('APP_ENV=development bundle exec rake db:environment:set db:drop db:create db:migrate')
    # rubocop:enable Layout/LineLength
  end
end
