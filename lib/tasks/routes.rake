# frozen_string_literal: true

namespace :routes do
  desc 'Print out all routes'
  task :show do
    require 'colorize'
    require 'sinatra/base'

    # Load the application
    require_relative '../../config/application'

    # Load the application routes
    ApplicationLoader.load_app

    # Print out all routes
    puts 'Endpoints of alpop-analysis:'.magenta.bold
    AlpopAnalysis.routes.each do |endpoints|
      endpoints.each_pair do |method, values|
        values.map do |route|
          puts "#{method.to_s.green.bold} #{route.first.to_s.yellow}"
        end
      end
    end
  end
end
