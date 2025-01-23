# frozen_string_literal: true

require 'dotenv/load'
Dotenv.load('.env')

namespace :db do
  desc 'Drop, create and migrate database for development environment'
  task :restart_dev do
    # rubocop:disable Layout/LineLength
    system('bundle exec rake db:environment:set db:drop db:create db:migrate db:seed RACK_ENV=development VERBOSE=true')
    # rubocop:enable Layout/LineLength
  end

  desc 'Drop, create and migrate database for test environment'
  task :restart_test do
    # rubocop:disable Layout/LineLength
    system('bundle exec rake db:environment:set db:drop db:create db:migrate db:seed RACK_ENV=test VERBOSE=true')
    # rubocop:enable Layout/LineLength
  end

  desc 'Drop, create and migrate test and development DB, plus annotate models'
  task :restart_dev_test do
    Rake::Task['db:restart_dev'].invoke
    Rake::Task['db:restart_test'].invoke
  end
end
