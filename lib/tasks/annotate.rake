# frozen_string_literal: true

namespace :annotate do
  desc 'Annotate models'
  task :models do
    sh 'RUBYLIB=. bundle exec annotaterb models'
  end
end
